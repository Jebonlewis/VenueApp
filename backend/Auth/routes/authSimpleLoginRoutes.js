

const express = require('express');
const bcrypt=require('bcrypt');
const routerSimpleLogin = express.Router();
const authService = require('../service/authSimpleLoginService');
const User=require('../models/User')
const {loginValidationSchema}=require('../validators/authValidators');

// Register route
// Login route
routerSimpleLogin.post('/', async (req, res, next) => {
  try {

    console.log('req.body',req.body);
//         // Validate request body
        const { error } = loginValidationSchema.validate(req.body);
        if (error) {
          console.log("Validation error:", error.details[0].message);
          return res.status(400).json({ error: error.details[0].message });
        }
    const { email, password } = req.body;


    // Find user by email
    const user = await User.findOne({ email: email });

    if (!user) {
      return res.status(400).json({ error: 'Invalid username ' });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(400).json({ error: 'Invalid password' });
    }
    console.log(user.authenticationType);
    const token = authService.generateToken(user._id,user.email,user.fullname,user.authenticationType,"user");
    res.status(200).json({ token: token });
  } catch (err) {
    console.error('Error occurred during login:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports =routerSimpleLogin ;

