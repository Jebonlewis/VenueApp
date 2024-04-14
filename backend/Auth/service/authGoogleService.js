const jwt = require('jsonwebtoken');
const axios = require('axios');
const User = require('../models/User');
const config=require('../config/authConfig');

async function processGoogleCallback(user) {
    try {
        const accessToken = user.accessToken;
        console.log(accessToken)
        const response = await axios.get(config.google.googleApi, {
            headers: {
                'Authorization': `Bearer ${accessToken}`
            }
        });
        
        const userDetails = {
            authenticationType: 'google',
            fullname: response.data.name,
            email: response.data.email
            // Add more fields as needed
        };
        console.log(userDetails);
        return userDetails;
    } catch (error) {
        throw error;
    }
}

async function generateAuthToken(userDetails) {
    try {
        const { email } = userDetails;
        const existingUser = await User.findOne({ email, authenticationType: 'google' });
        if (existingUser) {
            const token = jwt.sign({ user: existingUser }, config.google.jwtSecretGoogle,{expiresIn:'1h'});
            console.log(token);
            return token;
        } else {
            const existingUserNotGoogle = await User.findOne({ email });
            if (existingUserNotGoogle) {
                console.log("Email is already registered");
                return {error:'Email is already registered'};
            }
            const newUser = new User(userDetails);
            await newUser.save();
            const token = jwt.sign({ user: newUser }, config.google.jwtSecretGoogle,{expiresIn:'1h'});
            console.log(token);
            return token;
        }
    } catch (error) {
        throw error;
    }
}

module.exports = {
    processGoogleCallback,
    generateAuthToken
};
