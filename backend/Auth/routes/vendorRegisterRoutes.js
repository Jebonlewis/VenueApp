const express = require('express');
const routerVendorRegister = express.Router();
const routerBranch = express.Router();
const multer  = require('multer');
const vendorService = require('../service/vendorRegisterService');


// Define storage for the uploaded files
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/') // Specify the directory where files should be uploaded
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname) // Use the original file name for the uploaded file
    }
});

// Initialize multer with the defined storage
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

routerBranch.post('/', upload.single('image'), async (req, res) => {
    console.log("called branch");

    try {
        const { email, branchDetails } = req.body;

        // Query the database to find the vendor document based on the provided email
        const vendor = await vendorService.findVendorByEmail(email);

        if (!vendor) {
            throw new Error('Vendor not found');
        }

        // Extract the vendor ID from the vendor document
        const vendorId = vendor._id;

        // Check if file exists
        if (!req.file) {
            throw new Error('No image uploaded');
        }

        // Call the service function to update branch details and store image for the vendor
        const result = await vendorService.updateBranchDetailsWithImage(vendorId, branchDetails, req.file);
        res.status(200).json(result);
    } catch (error) {
        console.error('Error occurred while updating branch details:', error);
        res.status(400).json({ error: error.message });
    }
});


module.exports= {
    routerVendorRegister,
    routerBranch
}
