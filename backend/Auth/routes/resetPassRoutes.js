

// routes/authResetRoutes.js

const express = require('express');
const routerReset = express.Router();
const { generateAndSendOTP, resetPasswordWithOTP } = require('../service/resetService');

// Request OTP for password reset
routerReset.post('/', async (req, res) => {
  try {
    const { email } = req.body;
    const otp = await generateAndSendOTP(email);
    res.status(200).json({ message: 'OTP sent successfully', otp });
  } catch (error) {
    console.error('Error occurred during OTP request:', error);
    res.status(400).json({ error: error.message });
  }
});

// Reset password using OTP
routerReset.post('/reset', async (req, res) => {
  try {
    const { email, otp, newPassword } = req.body;
    const result = await resetPasswordWithOTP(email, otp, newPassword);
    res.status(200).json({ message: result });
  } catch (error) {
    console.error('Error occurred during password reset with OTP:', error);
    res.status(400).json({ error: error.message });
  }
});

module.exports = routerReset;

