const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Vendor = require('../models/Vendors');
const User = require('../models/User');
const Venue = require('../models/venue');
const { venueRegisterValidation} = require('../validators/venueValidators');
const {sendVerificationEmail}=require('../utils/mailUtil');
const config=require('../config/authConfig');

const verificationTokens = {};


async function venueRegister(userData) {
    try {
        // Validate user data
        const {error}= await venueRegisterValidation.validateAsync(userData);
        if (error) {
            console.log("Validation error:", error.details[0].message);
            return res.status(400).json({ error: error.details[0].message });
          }

        // Check if user already exists
        const existingUser = await User.findOne({ email: userData.email });
        const existingVendor = await Vendor.findOne({ email: userData.email });
        const existingVenue = await Venue.findOne({ email: userData.email });
        console.log("checkinggg");
        if (existingUser || existingVendor || existingVenue) {
            console.log('5');
            return {error:'Email is already registered'};
        }

        // Hash password
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (!passwordRegex.test(userData.password)) {
            console.log('Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.');
            return ({ error: 'Password must contain at  least one uppercase letter, one lowercase letter, one number, and one special character.' });
        }
        
        const hashedPassword = await bcrypt.hash(userData.password, 10);

        // Generate JWT token for email verification
        const jwtToken = jwt.sign({ fullname: userData.fullname, email: userData.email, password: hashedPassword },config.register.jwtSecretMail, { expiresIn: config.jwtExpiresIn });

        // Save verification token
        verificationTokens[jwtToken] = { fullname: userData.fullname, email: userData.email, password: hashedPassword };
        const UserType="venue";
        // Send verification email
        await sendVerificationEmail(userData.email, userData.fullname, jwtToken,UserType);

        return { message: 'Verification email sent' };
        }
        
        catch (error) {
            console.log('6');
            throw error;
        }
    }

async function verifyToken(token) {
    try {
        // Verify and decode JWT token
        const decoded = jwt.verify(token, config.register.jwtSecretMail);

        // Extract user data
        const { fullname, email, password } = decoded;

        // Check if email, password, and fullname are present
        if (!email || !password || !fullname) {
            console.log('1');
            throw new Error('Invalid token data');
        }

        // Hash the password
        if (verificationTokens[token]) {
        

        // Create new user
        const newVenue = new Venue({ fullname, email, password, authenticationType: 'simple' });
        await newVenue.save();

        // Delete verification token
        delete verificationTokens[token];

        return { success: true };

    } 
    else{
        console.log('2');
        return { error: 'Invalid or expired verification token' };
    }
    }
    catch (error) {
        console.log('3');
        // Send error response in case of any other errors
        return { error: 'An error occurred during registration'};
    }
}

module.exports = {
    venueRegister,
    verifyToken
};
