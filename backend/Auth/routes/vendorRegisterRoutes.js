const express = require('express');
const routerVendorRegister = express.Router();
const routerBranch = express.Router();

const multer  = require('multer');
const Vendor=require('../models/Vendors')
const vendorService = require('../service/vendorRegisterService');
const fs = require('fs');

const storage = multer.memoryStorage(); // Store files in memory

// Initialize multer with the defined storage
const upload = multer({ storage: storage, limits: { fileSize: 80 * 1024 * 1024 } });

// Register route
routerVendorRegister.post('/', async (req, res) => {
    try {
        console.log('checking vendor register');
        console.log('req.body',req.body);
        const result = await vendorService.vendorRegister(req.body);
        res.status(200).json(result);
    } catch (error) {
        console.log('4');
        console.error('Error occurred during vendor registration:', error);
        res.status(400).json({ error: error.message });
    }
});

// Verify route
routerVendorRegister.get('/verify', async (req, res) => {
    try {
        const { token } = req.query;
        const result = await vendorService.verifyToken(token);
        if (result.success) {
            const successMessage = 'Vendor registered successfully';  // Success message
            res.json({ message: successMessage }); // Redirect to signin page if verification is successful
        } else {
            //const errorMessage = encodeURIComponent(result.error || 'An error occurred during verification');
            res.json({error : 'An error occurred during verification'});  
              }
        //res.status(200).json(result);
    } catch (error) {
        console.log('7');
        console.error('Error occurred during email verification:', error);
        res.status(400).json({ error: error.message });
    }
});

// routerBranch.post('/', upload.single('image'), async (req, res) => {
routerBranch.post('/',  upload.single('image'),async (req, res) => {
    console.log("called branch");
    console.log(req.body);
    if (req.file) {
        console.log("imageFile:", req.file);
        const imageFile = {
            // buffer: fs.readFileSync(req.file.path), // Read file contents
            // originalname: req.file.originalname // Retain original name
            buffer: req.file.buffer, // Access the file buffer directly
            originalname: req.file.originalname 
        };
   
    
    try {
        const { email, branchDetails } = req.body;
        console.log(typeof(branchDetails));
        console.log(email);

        // Query the database to find the vendor document based on the provided email
        const vendor = await Vendor.findOne({ email: email }, '_id');

        if (!vendor) {
            throw new Error('Vendor not found');
        }

        // Extract the vendor ID from the vendor document
        const vendorId = vendor._id;
        console.log("vendorId 1  ",vendorId);
        // Check if file exists
        if (!req.file) {
            throw new Error('No image uploaded');
        }

        // Call the service function to update branch details and store image for the vendor
        const result = await vendorService.updateBranchDetailsWithImage(vendorId, branchDetails,imageFile);
        res.status(200).json(result);
    } catch (error) {
        console.error('Error occurred while updating branch details:', error);
        res.status(400).json({ error: error.message });
    }
}
else {
    console.log("No imageFile received");
}
});

module.exports= {
    routerVendorRegister,
    routerBranch
}
