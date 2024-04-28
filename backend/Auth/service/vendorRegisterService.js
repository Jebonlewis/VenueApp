const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Vendor = require('../models/Vendors');
const User = require('../models/User');
const Venue = require('../models/venue');
const { vendorRegisterValidation} = require('../validators/vendorValidators');
const {sendVerificationEmail}=require('../utils/mailUtil');
const config=require('../config/authConfig');
const multer = require('multer');
const { GridFSBucket } = require('mongodb');
const mongoose = require('mongoose');

const verificationTokens = {};


async function vendorRegister(vendorData) {
    try {
        // Validate user data
        const {error}=await vendorRegisterValidation.validateAsync(vendorData);
        if (error) {
            console.log("Validation error:", error.details[0].message);
            return res.status(400).json({ error: error.details[0].message });
          }

       

        // Check if user already exists
        const existingUser = await User.findOne({ email: vendorData.email });
        const existingVendor = await Vendor.findOne({ email: vendorData.email });
        const existingVenue = await Venue.findOne({ email: vendorData.email });
        if (existingUser || existingVendor || existingVenue) {
            console.log('5');
            return {error:'Email is already registered'};
        }

        // Hash password
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
        if (!passwordRegex.test(vendorData.password)) {
            console.log('Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.');
            return ({ error: 'Password must contain at  least one uppercase letter, one lowercase letter, one number, and one special character.' });
        }
        
        const hashedPassword = await bcrypt.hash(vendorData.password, 10);

        // Generate JWT token for email verification
        const jwtToken = jwt.sign({ fullname: vendorData.fullname, email: vendorData.email, password: hashedPassword ,serviceType:vendorData.serviceType},config.register.jwtSecretMail, { expiresIn: config.jwtExpiresIn });

        // Save verification token
        verificationTokens[jwtToken] = { fullname: vendorData.fullname, email: vendorData.email, password: hashedPassword ,serviceType:vendorData.serviceType};
        const UserType="vendor";
        // Send verification email
        await sendVerificationEmail(vendorData.email, vendorData.fullname, jwtToken,UserType);

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
        const { fullname, email, password,serviceType } = decoded;

        // Check if email, password, and fullname are present
        if (!email || !password || !fullname || !serviceType) {
            console.log('1');
            throw new Error('Invalid token data');
        }

        // Hash the password
        if (verificationTokens[token]) {
        

        // Create new user
        const newVendor = new Vendor({ fullname, email, password,serviceType, authenticationType: 'simple' });
        await newVendor.save();

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




async function updateBranchDetailsWithImage(vendorId, branchDetails, imageFile) {
    try {
       

        const vendor = await Vendor.findById(vendorId);

        if (!vendor) {
            throw new Error('Vendor not found');
        }
        branchDetails = JSON.parse(branchDetails);
        
        vendor.branchName = branchDetails.branchName;
        vendor.aboutBranch = branchDetails.aboutBranch;
        vendor.address = branchDetails.address;
        vendor.city = branchDetails.city;
        vendor.state = branchDetails.state;
        vendor.country = branchDetails.country;

        // Store image in GridFS
        
        // Save the updated vendor document
        await vendor.save();

        return { success: true, message: 'Branch details and image updated successfully' };
    } catch (error) {
        console.error('Error occurred while updating branch details:', error);
        return { success: false, error: error.message };
    }
}

module.exports = {
    vendorRegister,
    verifyToken,
    updateBranchDetailsWithImage
    //vendorRegister
};
