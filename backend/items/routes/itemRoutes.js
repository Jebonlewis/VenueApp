const express = require('express');
const routerItem = express.Router();
const routerItemDisplay = express.Router();
const itemService = require('../service/itemService');
const fs = require('fs');
const multer  = require('multer');
const Vendor = require('../../Auth/models/Vendors');
const Item = require('../models/Items');
const mongoose = require('mongoose');
const config=require('../../Auth/config/authConfig');
const { GridFSBucket,
   ObjectID } = require('mongodb');
const path=require('path');


const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      // Specify the directory where images will be stored
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      // Generate a unique filename using the document id
      const filename = file.originalname; // You can customize the filename if needed
      cb(null, filename);
    }
  });
  
  const upload = multer({ storage: storage });
  
  routerItem.post('/', upload.single('image'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No image file received' });
        }

        const { email, itemDetails } = req.body;
        const vendor = await Vendor.findOne({ email: email }, '_id');

        if (!vendor) {
            throw new Error('Vendor not found');
        }

        const vendorId = vendor._id;
        const itemDetail = JSON.parse(itemDetails);

        // Create a new item document
        const newItem = new Item({
            vendorId: vendorId,
            itemName: itemDetail.itemName,
            aboutItem: itemDetail.aboutItem,
            price: itemDetail.price,
            // Other item details here...
        });

        // Save the new item to the database
        await newItem.save();

        // Move the uploaded image to the folder with its name as the id of the document
        const imagePath = `uploads/${newItem._id}.${req.file.originalname.split('.').pop()}`;
        fs.renameSync(req.file.path, imagePath);

        return res.status(201).json({ success: true, message: 'Item created successfully' });
    } catch (error) {
        console.error('Error creating item:', error);

        // If an error occurs, delete the uploaded image
        if (req.file) {
            fs.unlinkSync(req.file.path);
        }

        return res.status(400).json({ error: 'Failed to create item' });
    }
});

// routerItemDisplay.get('/', async (req, res) => {
//   try {
//     // Extract the vendor ID from the request parameters
//     const email = req.query.email;
//     const vendor = await Vendor.findOne({ email: email }, '_id');
//     const vendorId = vendor._id;

//     // Find all items belonging to the vendor
//     const items = await Item.find({ vendorId: vendorId }, '_id');

//     const images = [];

//     // Iterate through each item to send image files
//     for (const item of items) {
//       // Construct the filename using the item ID
//       const filename = `${item._id}.jpg`; // Assuming the images have a '.jpg' extension

//       // Check if the image file exists in the folder
//       const imagePath = path.join(__dirname, '..', '..', 'uploads', filename);

//       if (fs.existsSync(imagePath)) {
//         // Read the image file and encode it as base64
//         const imageBuffer = fs.readFileSync(imagePath);
//         const base64Image = imageBuffer.toString('base64');

//         // Push the filename and base64 encoded image to the images array
//         images.push({ filename: filename, image: base64Image });
//       }
//     }

//     // Send the images array as JSON response
//     res.json(images);
//   } catch (error) {
//     console.error('Error retrieving images:', error);
//     res.status(500).json({ error: 'Failed to retrieve images' });
//   }
// });

routerItemDisplay.get('/', async (req, res) => {
  try {
    // Extract the vendor ID from the request parameters
    const email = req.query.email;
    const vendor = await Vendor.findOne({ email: email }, '_id');
    const vendorId = vendor._id;

    // Find all items belonging to the vendor
    const items = await Item.find({ vendorId: vendorId });

    const dataToSend = [];

    // Iterate through each item
    for (const item of items) {
      // Construct the filename using the item ID
      const filename = `${item._id}.jpg`; // Assuming the images have a '.jpg' extension

      // Check if the image file exists in the folder
      const imagePath = path.join(__dirname, '..', '..', 'uploads', filename);

      if (fs.existsSync(imagePath)) {
        // Read the image file and encode it as base64
        const imageBuffer = fs.readFileSync(imagePath);
        const base64Image = imageBuffer.toString('base64');

        // Push the filename and base64 encoded image to the images array
        const imageData = { filename: filename, image: base64Image };
        
        // Add item details to the data
        const itemData = {
          itemDetails: item,
          imageData: imageData
        };

        dataToSend.push(itemData);
      }
    }

    // Send the data array as JSON response
    res.json(dataToSend);
  } catch (error) {
    console.error('Error retrieving images:', error);
    res.status(500).json({ error: 'Failed to retrieve images and item data' });
  }
});


module.exports ={ 
routerItem,
routerItemDisplay
}
