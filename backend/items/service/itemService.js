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
    const item = await Item.findOne({ vendorId: vendorId }, '_id');
    const itemId=item._id
    console.log(itemId)
    if (!item) {
      throw new Error('Item not found with the provided vendor ID');
    }
    // Find all images with matching vendorId
    const images = await gfs.find({ 'metadata.vendorId': new ObjectID(itemId) }).toArray();
    console.log(images);
    return images;
  } catch (error) {
    throw error;
  }
}

module.exports = {
  createItem,
  getImagesByVendorId
};
