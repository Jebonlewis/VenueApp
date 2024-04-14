// routes/authGoogleRoutes.js
const express = require('express');
const routerGoogle = express.Router();
const axios = require('axios');
const config = require('../config/authConfig');
const passport = require('../config/authGooglePassport');

// Redirect to Google OAuth for authentication
routerGoogle.get('/auth/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Google OAuth callback route
routerGoogle.get('/auth/google/callback', passport.authenticate('google', { failureRedirect: '/login' }), (req, res) => {
  res.redirect('/profile'); // Redirect to profile or dashboard page
});

// Profile route (protected route)
routerGoogle.get('/profile', (req, res) => {
  if (req.isAuthenticated()) {
    // User is authenticated, you can access user details from req.user
    res.send(`Authenticated user: ${req.user.displayName}`);
  } else {
    res.redirect('/auth/google'); // Redirect to Google OAuth if not authenticated
  }
});

module.exports = routerGoogle;
