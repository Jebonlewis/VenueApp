const express = require('express');
const routerItem = express.Router();
const routerItemDisplay = express.Router();
const itemService = require('../service/itemService');
const fs = require('fs');
const multer  = require('multer');
const Vendor = require('../../Auth/models/Vendors');

const storage = multer.memoryStorage(); // Store files in memory

// Initialize multer with the defined storage
const upload = multer({ storage: storage, limits: { fileSize: 80 * 1024 * 1024 } });

// Route to create a new item
routerItem.post('/',upload.single('image') ,async (req, res) => {
  try {
    console.log("called item");
    if (req.file) {
      console.log("imageFile:", req.file);
      const imageFile = {
          // buffer: fs.readFileSync(req.file.path), // Read file contents
          // originalname: req.file.originalname // Retain original name
          buffer: req.file.buffer, // Access the file buffer directly
          originalname: req.file.originalname 
      };
  
    const { email, itemDetails} = req.body;
        console.log(req.body);
        console.log("item detailes",itemDetails);
        console.log(typeof(itemDetails));
        console.log(email);

        // Query the database to find the vendor document based on the provided email
        const vendor = await Vendor.findOne({ email: email }, '_id');
        if (!vendor) {
            throw new Error('Vendor not found');
        }

        // Extract the vendor ID from the vendor document
        const vendorId = vendor._id;
        console.log("vendorId 1  ",vendorId);
    const newItem = await itemService.createItem(itemDetails,imageFile,vendorId);
    res.status(201).json(newItem);
      }
  else {
    console.log("No imageFile received");
  }
  } catch (error) {
    console.error('Error creating item:', error);
    res.status(400).json({ error: 'Failed to create item' });
  }
});

// Add more routes as needed...

routerItemDisplay.get('/', async (req, res) => {
  try {
    const email = req.query.email;
    const vendor = await Vendor.findOne({ email: email }, '_id');
    const vendorId=vendor._id;
    const images = await itemService.getImagesByVendorId(vendorId);
    res.json(images);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});



module.exports ={ 
routerItem,
routerItemDisplay
}
