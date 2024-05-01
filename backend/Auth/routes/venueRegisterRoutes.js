const express = require('express');
const routerVenueRegister = express.Router();
const venueService = require('../service/venueRegisterService');

// Register route
routerVenueRegister.post('/', async (req, res) => {
    try {
        console.log('checking venue register');
        console.log('req.body',req.body);
        const result = await venueService.venueRegister(req.body);
        res.status(200).json(result);
    } catch (error) {
        console.log('4');
        console.error('Error occurred during venue registration:', error);
        res.status(400).json({ error: error.message });
    }
});

// Verify route
routerVenueRegister.get('/verify', async (req, res) => {
    try {
        const { token } = req.query;
        const result = await venueService.verifyToken(token);
        if (result.success) {
            const successMessage = 'Venue registered successfully';  // Success message
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

module.exports= routerVenueRegister;
