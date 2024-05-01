const User = require('../models/User');
const Vendor=require('../models/Vendors');
const Venue=require('../models/venue');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const config=require('../config/authConfig');
const { error } = require('console');

// Function to generate a random OTP
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000); // Generate a 6-digit OTP
}

// Function to send OTP to the user's email
async function sendOTP(email, otp) {
  try {
    // Create a transporter for sending emails (update with your email service provider)
    const user = await User.findOne({ email });
    const vendor=await Vendor.findOne({email});
    const venue=await Venue.findOne({email});
    let fullname
    
    if (!user && !venue && !vendor) {
      throw new Error('user dosent exits');
    }
    if (user){
      fullname=user.fullname;
    }
    if (vendor){
      fullname=vendor.fullname;
    }
    if (venue){
      fullname=venue.fullname;
    }
    const transporter = nodemailer.createTransport({
      service: config.mail.emailService,
      auth: {
        user: config.mail.emailUser,
        pass: config.mail.emailPass
      }
    });

    // Email content
    const mailOptions = {
      from: config.mail.emailUser,
      to: email,
      subject: 'Password Reset OTP',
      text: `Hi ${fullname},
    Your OTP for password reset is: ${otp}`,
    };

    // Send email
    await transporter.sendMail(mailOptions);
  } catch (error) {
    console.error('Error occurred while sending OTP email:', error);
    throw new Error('Failed to send OTP email');
  }
}
// Function to generate OTP and send it to the user's email
// Function to generate OTP and send it to the user's email
async function generateAndSendOTP(email) {
  try {
    const otp = generateOTP();
    console.log('otp', otp);

    // Send OTP to the user's email
    await sendOTP(email, otp);

    // Store OTP and its expiration time in the user document
    const expiration = new Date();
    expiration.setMinutes(expiration.getMinutes() + 5); // OTP expires in 5 minutes
    const user = await User.findOne({ email });
    const vendor=await Vendor.findOne({email});
    const venue=await Venue.findOne({email});
    
    if (!user && !venue && !vendor) {
      throw new Error('user dosent exits');
    }
    if (user){
      await User.updateOne({ email }, { otp, otpExpires: expiration });
    }
    if (vendor){
      await Vendor.updateOne({ email }, { otp, otpExpires: expiration });
    }
    if (venue){
      await Venue.updateOne({ email }, { otp, otpExpires: expiration });
    }

    return otp;
  } catch (error) {
    console.error('Error occurred during OTP generation and sending:', error);
    throw new Error('Failed to generate and send OTP');
  }
}

// Function to reset password using OTP
async function validateOtp(email, otp) {
  try {
    // Find the user by email and verify the OTP
    let user = await User.findOne({ email });
    let vendor=await Vendor.findOne({email});
    let venue=await Venue.findOne({email});
    
    if (user){
      user = await User.findOne({
        email,
        otp,
        otpExpires: { $gt: Date.now() }, // Check if OTP is not expired
      });
      console.log(user);
    console.log("user otp",otp);
    console.log("db otp",user.otp);
    console.log("db otp",user.otpExpires);
    }
    if (vendor){
      vendor = await Vendor.findOne({
        email,
        otp,
        otpExpires: { $gt: Date.now() }, // Check if OTP is not expired
      });

      console.log(vendor);
    console.log("user otp",otp);
    console.log("db otp",vendor.otp);
    console.log("db otp",vendor.otpExpires);
    }
    if (venue){
      venue = await Venue.findOne({
        email,
        otp,
        otpExpires: { $gt: Date.now() }, // Check if OTP is not expired
      });
      console.log(venue);
      console.log("user otp",otp);
      console.log("db otp",venue.otp);
      console.log("db otp",venue.otpExpires);
      
    }

    if (!user && !venue && !vendor) {
      return { success: false, message: 'Invalid or expired OTP' };
    }


    if (user){
      user.otp = undefined;
      user.otpExpires = undefined;
      await user.save();
    }
    if (vendor){
      vendor.otp = undefined;
      vendor.otpExpires = undefined;
    await vendor.save();
    }
    if (venue){
      venue.otp = undefined;
      venue.otpExpires = undefined;
    await venue.save();
    }
    // Clear OTP and its expiration time
    

    return { success: true, message: 'OTP matched successfully' };
  } catch (error) {
    console.error('Error occurred during password reset with OTP:', error);
    return { success: false, message: 'An error occurred during password reset with OTP' };
  }
}


async function changePassword(email, newPassword, confirmPassword) {
  try {
    // Input validation
    if (!email || !newPassword || !confirmPassword) {
      throw new Error('Missing required parameters');
    }

    if (newPassword === confirmPassword) {
      const hashedPassword = await bcrypt.hash(newPassword, 10);

    const user = await User.findOne({ email });
    const vendor=await Vendor.findOne({email});
    const venue=await Venue.findOne({email});
    
    if (!user && !venue && !vendor) {
      throw new Error('user dosent exits');
    }
    if (user){
       const updatedUser = await User.findOneAndUpdate(
        { email: email },
        { password: hashedPassword }, // Update only the password field
        { new: true } // To return the updated document
      );
      if (updatedUser) {
        console.log('User updated successfully:', updatedUser);
        return { message: 'Your password has been changed' };
      }
    }
    if (vendor){
      const updatedVendor = await Vendor.findOneAndUpdate(
        { email: email },
        { password: hashedPassword }, // Update only the password field
        { new: true } // To return the updated document
      );
      if (updatedVendor) {
        console.log('User updated successfully:', updatedVendor);
        return { message: 'Your password has been changed' };
      }
    }
    if (venue){
      const updatedVenue = await Venue.findOneAndUpdate(
        { email: email },
        { password: hashedPassword }, // Update only the password field
        { new: true } // To return the updated document
      );
      if (updatedVenue) {
        console.log('User updated successfully:', updatedVenue);
        return { message: 'Your password has been changed' };
      }
    }
        throw new Error('User not found or update failed.');
      
    } else {
      throw new Error('Passwords do not match');
    }
  } catch (error) {
    console.error('Error occurred changing the password:', error);
    throw new Error('Unable to reset password');
  }
}
module.exports = { generateAndSendOTP, validateOtp,changePassword };