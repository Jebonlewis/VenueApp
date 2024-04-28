

const express = require('express');
const bcrypt=require('bcrypt');
const routerVenueLogin = express.Router();
const authService = require('../service/venueSimpleLoginService');
const Venue=require('../models/venue')
const {venueLoginValidation}=require('../validators/venueValidators');

// Register route
// Login route
routerVenueLogin.post('/', async (req, res, next) => {
  try {

    console.log('req.body',req.body);
//         // Validate request body
        const { error } = venueLoginValidation.validate(req.body);
        if (error) {
          console.log("Validation error:", error.details[0].message);
          return res.status(400).json({ error: error.details[0].message });
        }
    const { email, password } = req.body;


    // Find user by email
    const venue = await Venue.findOne({ email: email });

    if (!venue) {
     
      return res.status(400).json({ error: 'Invalid username' });
    }

    const passwordMatch = await bcrypt.compare(password, venue.password);
 
    if (!passwordMatch) {
    
      return res.status(400).json({ error: 'Invalid  password' });
    }
    
    console.log(venue.authenticationType);
    const token = authService.generateToken(venue._id,venue.email,venue.fullname,venue.authenticationType,"venue");
    res.status(200).json({ token: token });
  } catch (err) {
    console.error('Error occurred during login:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports =routerVenueLogin ;

