
const express = require('express');
const routerLogout = express.Router();
const User = require('../models/User'); // Import your user model

routerLogout.get('/', async (req, res, next) => {
    try {
        console.log("User object:", req.user); 
        const userEmail = req.user && req.user.profile.email; // Safely access email property
        console.log("User email:", userEmail); // Logging for debugging

        // Fetch user from database using email
        const user = await User.findOne({ email: userEmail });

        console.log("User:", user); // Logging for debugging

        // Perform logout operations
        req.logout((err) => {
            if (err) {
                return next(err);
            }
            res.clearCookie('auth_token');
            req.session.destroy();

            // Now send the response
            if (user && user.fullname) {
                res.send(`You have been logged out, ${user.fullname}`);
            } else {
                res.send('You have been logged out');
            }
        });
    } catch (error) {
        // Handle error
        next(error);
    }
});

module.exports = routerLogout;
