// mailutil.js
const nodemailer = require('nodemailer');
const config=require('../config/authConfig');
// Create a transporter using Gmail service
const transporter = nodemailer.createTransport({
    service: config.mail.emailService,
    auth: {
      user: config.mail.emailUser,
      pass: config.mail.emailPass
    }
});

// Function to send verification email
async function sendVerificationEmail(email,fullname,jwtToken,UserType) {
  console.log("UserType",UserType);
    try {
        // Define email options
        let verificationUrl = '';
        if (UserType === 'vendor') {
          verificationUrl = config.mail.vendorEmailVerificationUrl;
        }
        else if (UserType === 'venue') {
          verificationUrl = config.mail.venueEmailVerificationUrl;
        }
         else {
          verificationUrl = config.mail.userEmailVerificationUrl;
        }
        console.log(verificationUrl);
        const mailOptions = {
            from: config.mail.emailUser,
            to: email,
            subject: 'Email Verification',
            html: `<p>Hi ${fullname},</p>
            <p>Welcome to VenueApp! Please click on the link below to verify your email address:</p>
            <p><a href="${verificationUrl}${jwtToken}">Verify Email</a></p>
            <p>If you did not sign up for VenueApp, please ignore this email.</p>`
            };

        // Send email
        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent: ' + info.response);
    } catch (error) {
        console.error('Error sending verification email:', error);
        throw new Error('Error sending verification email');
    }
}

module.exports = {
    sendVerificationEmail
};
