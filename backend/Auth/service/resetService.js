const User = require('../models/User');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const config=require('../config/authConfig')

// Function to generate a random OTP
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000); // Generate a 6-digit OTP
}

// Function to send OTP to the user's email
async function sendOTP(email, otp) {
  // Create a transporter for sending emails (update with your email service provider)
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
}

// Function to generate OTP and send it to the user's email
async function generateAndSendOTP(email) {
  const otp = generateOTP();
  await sendOTP(email, otp);

  // Store OTP and its expiration time in the user document
  const expiration = new Date();
  expiration.setMinutes(expiration.getMinutes() + 5); // OTP expires in 5 minutes
  await User.updateOne({ email }, { otp, otpExpires: expiration });

  return otp;
}

// Function to reset password using OTP
async function resetPasswordWithOTP(email, otp, newPassword) {
  // Find the user by email and verify the OTP
  const user = await User.findOne({
    email,
    otp,
    otpExpires: { $gt: Date.now() }, // Check if OTP is not expired
  });

  if (!user) {
    throw new Error('Invalid or expired OTP');
  }

  // Hash the new password
  const hashedPassword = await bcrypt.hash(newPassword, 10);
  user.password = hashedPassword;
  user.otp = undefined; // Clear OTP and its expiration time
  user.otpExpires = undefined;
  await user.save();

  return 'Password reset successful';
}

module.exports = { generateAndSendOTP, resetPasswordWithOTP };