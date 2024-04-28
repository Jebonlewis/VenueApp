const express = require('express');
const routerVendorRegister = express.Router();
const routerBranch = express.Router();
const Vendor=require('../models/Vendors')
const VendorLocation=require('../../location/models/vendorLocation')
const vendorService = require('../service/vendorRegisterService');
const fs = require('fs');
const multer  = require('multer');
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
    routerBranch.post('/', upload.single('image'), async (req, res) => {
        try {
            if (!req.file) {
                return res.status(400).json({ error: 'No image file received' });
            }
    
            const { email, branchDetails } = req.body;
            console.log(typeof branchDetails);
            console.log(branchDetails);
            console.log(email);
    
            // Query the database to find the vendor document based on the provided email
            const vendor = await Vendor.findOne({ email });
    
            if (!vendor) {
                throw new Error('Vendor not found');
            }
    
            // Extract the vendor ID from the vendor document
            const vendorId = vendor._id;
            console.log("vendorId 1  ", vendorId);
            const branchDetail = JSON.parse(branchDetails);
            console.log("latitude", typeof branchDetail['latitude']);
            console.log("Longitude", typeof branchDetail['longitude']);
            console.log("latitude", branchDetail['latitude']);
            console.log("Longitude", branchDetail['longitude']);
            const latitude = parseFloat(branchDetail['latitude']);
            const longitude = parseFloat(branchDetail['longitude']);
            console.log("latitude", latitude);
            console.log("Longitude", longitude);
            // Check if latitude and longitude are valid
            if (isNaN(latitude) || isNaN(longitude)) {
                throw new Error('Invalid latitude or longitude');
            }
    
            const location = {
                type: "Point",
                coordinates: [longitude, latitude],
            };
    
            // Update vendor branch details
            vendor.branchName = branchDetail.branchName;
            vendor.aboutBranch = branchDetail.aboutBranch;
            vendor.address = branchDetail.address;
            vendor.city = branchDetail.city;
            vendor.state = branchDetail.state;
            vendor.country = branchDetail.country;
    
            // Save the updated vendor document
            await vendor.save();
    
            // Save the VenueLocation document to the database only if the vendor details are successfully saved
            const newVendorLocation = new VendorLocation({
                vendorDetails_id: vendorId,
                location
            });
            savedVenueLocation = await newVendorLocation.save();
            const location_id = savedVenueLocation._id;
    
            vendor.location_id = location_id;
            await vendor.save();
            // Rename the uploaded image file with vendor ID
            const imagePath = `uploads/${vendor._id}.${req.file.originalname.split('.').pop()}`;
            fs.renameSync(req.file.path, imagePath);
    
            return res.status(201).json({ success: true, message: 'Item created successfully' });
    
        } catch (error) {
            console.error('Error occurred while updating branch details:', error);
            if (req.file) {
                fs.unlinkSync(req.file.path);
            }
            res.status(400).json({ error: error.message });
        }
    });

module.exports= {
    routerVendorRegister,
    routerBranch
}
