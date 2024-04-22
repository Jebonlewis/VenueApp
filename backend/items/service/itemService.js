const Item = require('../models/Items');
const mongoose = require('mongoose');
const config=require('../../Auth/config/authConfig');
const { GridFSBucket,
   ObjectID } = require('mongodb');
async function createItem(itemData, imageFile, vendorId) {
  try {
    await mongoose.connect(config.db.dbUrl);

    // Once connected, initialize GridFSBucket
    
    const gfs = new GridFSBucket(mongoose.connection.db, {
      bucketName: 'vendorItemImage'
    });
    // Now you can use `gfs` for file storage operations
    // Create a new item document
   itemData=JSON.parse(itemData);
    
    const newItem = new Item({
      vendorId: vendorId,
      itemName: itemData.itemName,
      aboutItem: itemData.aboutItem,
      price: itemData.price,
      // Other item details here...
    });

    // Save the new item to the database
    

    // If an image file is provided, store it in GridFS
   
      const writeStream = gfs.openUploadStream(imageFile.originalname, {
        metadata: {itemId: newItem._id} // Store the item ID as metadata
        
      });

      writeStream.write(imageFile.buffer);
      writeStream.end();
      await newItem.save();
      return { success: true, message: 'item details and image updated successfully' };
    }

 catch (error) {
    console.error('Error creating item:', error);
    throw error;
  }
}

async function getImagesByVendorId(vendorId) {
  try {
    // Connect to MongoDB
    console.log("running");
    await mongoose.connect(config.db.dbUrl);

    // Initialize GridFSBucket
    const gfs = new GridFSBucket(mongoose.connection.db, {
      bucketName: 'vendorItemImage'
    });
    console.log('gfs',gfs);
    const item = await Item.findOne({ vendorId: vendorId }, '_id');
    console.log('item',item);
    const itemId=item._id
    console.log("itemId",itemId)
    if (!item) {
      throw new Error('Item not found with the provided vendor ID');
    }
    // Find all images with matching vendorId
    // console.log("working")
     const images = await gfs.find({ 'metadata.itemId': itemId }).toArray();
     console.log("not working");
    // const distinctImages = await gfs.find({ 'metadata.itemId': itemId }).distinct('_id');
    // console.log("distinctImages",distinctImages);
    
    // // Fetch image data for each distinct image
    // const images = await Promise.all(distinctImages.map(async (imageId) => {
    //   console.log("Fetching image data for imageId:", imageId);
    //   const imageData = await gfs.findOne({ _id: imageId });
    //   console.log("Image data:", imageData);
    //   return imageData;
    // }));
    
    //console.log("images", images);
    return images;
    
  } catch (error) {
    throw error;
  }
}
module.exports = {
  createItem,
  getImagesByVendorId
};
