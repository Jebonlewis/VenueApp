

// routes/authResetRoutes.js

const express = require('express');
const routerSendOtp = express.Router();
const routerValidateOtp = express.Router();
const routerChangePassword = express.Router();
const { generateAndSendOTP, validateOtp,changePassword } = require('../service/resetService');

// Request OTP for password reset
routerSendOtp.post('/', async (req, res) => {
  try {
    console.log("otp send");
    const { email } = req.body;
    const otp = await generateAndSendOTP(email);
    res.status(200).json({ message: 'OTP sent successfully', otp });
  } catch (error) {
    console.error('Error occurred during OTP request:', error);
    res.status(400).json({ error: error.message });
  }
});

// Reset password using OTP
routerValidateOtp.post('/', async (req, res) => {
  try {
    console.log('called');
    const { email, otp } = req.body;
    const result = await validateOtp(email, otp);
    res.status(200).json({ result });
  } catch (error) {
    console.error('Error occurred during password reset with OTP:', error);
    res.status(400).json({ error: error.message });
  }
});

routerChangePassword.post('/',async(req,res)=>{
  
  try {
    console.log("called");
    const {email, newPassword, confirmPassword } = req.body;
    console.log(email,newPassword,confirmPassword);
    const result = await changePassword(email,newPassword, confirmPassword);
    res.status(200).json({ message: result });
  } catch (error) {
    console.error('Error occurred during password reset with OTP:', error);
    res.status(400).json({ error: error.message });
  }

});

module.exports = {routerSendOtp,
  routerValidateOtp,
  routerChangePassword
};

