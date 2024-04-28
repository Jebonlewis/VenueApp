

const express = require('express');
const bcrypt=require('bcrypt');
const routerVendorLogin = express.Router();
const authService = require('../service/vendorSimpleLoginService');
const Vendor=require('../models/Vendors')
const {vendorLoginValidation}=require('../validators/vendorValidators');

// Register route
// Login route
routerVendorLogin.post('/', async (req, res, next) => {
  try {

    console.log('req.body',req.body);
         // Validate request body
        const { error } = vendorLoginValidation.validate(req.body);
        if (error) {
          console.log("Validation error:", error.details[0].message);
          return res.status(400).json({ error: error.details[0].message });
        }
    const { email, password } = req.body;


    // Find user by email
    const vendor = await Vendor.findOne({ email: email });

    if (!vendor) {
     
      return res.status(400).json({ error: 'Invalid username' });
    }

    const passwordMatch = await bcrypt.compare(password, vendor.password);
 
    if (!passwordMatch) {
    
      return res.status(400).json({ error: 'Invalid password' });
    }
    
    console.log(vendor.authenticationType);
    const token = authService.generateToken(vendor._id,vendor.email,vendor.fullname,vendor.authenticationType,vendor.serviceType,"vendor");
    res.status(200).json({ token: token });
  } catch (err) {
    console.error('Error occurred during login:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports =routerVendorLogin ;

