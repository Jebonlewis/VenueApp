const express = require('express');
const routerRegister = express.Router();
const authService = require('../service/authRegister');

// Register route
routerRegister.post('/', async (req, res) => {
    try {
        console.log('checking register');
        console.log('req.body',req.body);
        const result = await authService.register(req.body);
        res.status(200).json(result);
    } catch (error) {
        console.log('4');
        console.error('Error occurred during user registration:', error);
        res.status(400).json({ error: error.message });
    }
});

// Verify route
routerRegister.get('/verify', async (req, res) => {
    try {
        const { token } = req.query;
        const result = await authService.verifyToken(token);
        if (result.success) {
            const successMessage = 'User registered successfully';  // Success message
            res.json({ message: successMessage }); // Redirect to signin page if verification is successful
        } else {
            const errorMessage = encodeURIComponent(result.error || 'An error occurred during verification');
            res.redirect(`https://localhost:5173/signup?error=${errorMessage}`);        }
        //res.status(200).json(result);
    } catch (error) {
        console.log('7');
        console.error('Error occurred during email verification:', error);
        res.status(400).json({ error: error.message });
    }
});

module.exports= routerRegister;
