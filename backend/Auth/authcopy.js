const express = require('express');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bodyParser = require('body-parser');
const session = require('express-session');
const mongoose = require('mongoose');
const fs = require('fs');
const https = require('https');
const GoogleStrategy = require('passport-google-oauth2').Strategy;
const FacebookStrategy = require('passport-facebook').Strategy;

const { body, validationResult } = require('express-validator');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const axios=require('axios');
const cookieParser = require('cookie-parser');
const cookie = require('cookie');
const Joi = require('joi');

const app = express();
const port = 443;


const verificationTokens = {};

// Nodemailer setup
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'hackathonannova@gmail.com',
    pass: 'wmrs korv trik gljn'
  }
});
// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/VenuApp');

// Define user schema
const userSchema = new mongoose.Schema({
  fullname: String,
  email: String,
  password: String,
  authenticationType: {
    type: String,
    enum: ['google', 'facebook', 'simple']
  }
});
function isLoggedIn(req, res, next) {
  req.user ? next() : res.sendStatus(401);
}
// Create user model
const User = mongoose.model('User', userSchema);

// Middleware


const userValidationSchema = Joi.object({
  fullname: Joi.string().required().messages({
    'string.empty': 'fullname  is required'}),
  email: Joi.string().email().required().messages({
    'string.email': 'Email must be a valid email address',
    'string.empty': 'email is required'}),
  password: Joi.when('authenticationType', {
    is: Joi.not('google', 'facebook'),
    then: Joi.string().required().min(8).messages({ 
      'string.empty': 'Password is required',
      'any.required': 'Password is required',
      'string.min': 'Password must be at least 8 characters long'
     }),
    otherwise: Joi.string().allow('').optional()
  }),
  confirmPassword: Joi.string().when('authenticationType', {
    is: Joi.not('google', 'facebook'),
    then: Joi.string().valid(Joi.ref('password')).required().messages({ 'any.only': 'Passwords must match' }),
    otherwise: Joi.string().allow('').optional()
  }),
  authenticationType: Joi.string().valid('google', 'facebook', 'simple').optional()
});

const loginValidationSchema = Joi.object({
  email: Joi.string().email().required().messages({
    'string.email': 'Email must be a valid email address',
    'string.empty': 'email is required'}),
  password: Joi.string().required().min(8).messages({ 
    'string.empty': 'Password is required',
    'any.required': 'Password is required',
    'string.min': 'Password must be at least 8 characters long'
   }),
});


app.use(bodyParser.json());

app.use(cookieParser());
app.use(session({ secret: 'dogs', resave: false, saveUninitialized: true }));
app.use(passport.initialize());
app.use(passport.session());
// Local strategy for username/password authentication
passport.use(new LocalStrategy({ usernameField: 'email', passwordField: 'password' },
  function(email, password, done) {
    console.log(email, password);
    User.findOne({ email: email })
      .then(user => {
        if (!user) { return done(null, false, { message: 'Incorrect email or password' }); }
        bcrypt.compare(password, user.password, function(err, result) {
          if (err) {
            return done(err);
          }
          if (!result) {
            return done(null, false, { message: 'Incorrect email or password' });
          }
          return done(null, user);
        });
      })
      .catch(err => {
        return done(err);
      });
  }
));

passport.use(new GoogleStrategy({
  clientID: "437139881682-kqisnb3c0k7to308uacbh7bklvnou9tq.apps.googleusercontent.com",
  clientSecret: "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",
  callbackURL: "https://localhost:443/auth/google/callback",
  passReqToCallback: true,
  scope:['profile'],
},
function(request, accessToken, refreshToken, profile, done) {
  //console.log(profile)
  request.user = {
    accessToken: accessToken,
    profile: profile
  };
  // Pass the user object to the done callback
  return done(null, request.user);
}));

passport.use(new FacebookStrategy({
  clientID: 'your-facebook-app-id',
  clientSecret: 'your-facebook-app-secret',
  callbackURL: 'https://your-domain/auth/facebook/callback',
  profileFields: ['id', 'displayName', 'email']
}, (accessToken, refreshToken, profile, done) => {
  // Use profile information to create or authenticate user
  // Example logic to create or find user in your database:
  // User.findOrCreate({ facebookId: profile.id }, function (err, user) {
  //   return done(err, user);
  // });
}));


passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(user, done) {
  done(null, user);
});

app.get('/', async (req, res) => {
  res.send('<a href="/auth/google">Authenticate with Google</a>');
});


app.post('/register', async (req, res) => {
  const { error, value } = userValidationSchema.validate(req.body);

  // Check for validation errors
  if (error) {
    return res.status(400).json({ error: error.details[0].message });
  }

  // Proceed with user registration if validation passes
  const { fullname, email, password, authenticationType } = value;

  const existingUser = await User.findOne({ email: email });
  if (existingUser) {
    return res.status(400).json({ error: 'Email is already registered' });
  }

  // Generate a unique verification token
  //const token = crypto.randomBytes(32).toString('hex');
  //verificationTokens[token] = { fullname,email, password };
  const jwtToken = jwt.sign({ fullname, email, password }, 'email_verify', { expiresIn: '1h' });
  verificationTokens[jwtToken] = { fullname, email, password };
  // Send verification email
  const mailOptions = {
    from: 'hackathonannova@gmail.com',
    to: email,
    subject: 'Email Verification',
    html:`<p>Hi ${fullname},</p>
    <p>Welcome to YourApp! Please click on the link below to verify your email address:</p>
    <p><a href="https://localhost:443/verify?token=${jwtToken}">Verify Email</a></p>
    <p>If you did not sign up for YourApp, please ignore this email.</p>`
  };
transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error(error);
      res.status(500).send('Error sending verification email');
    } else {
      console.log('Email sent: ' + info.response);
      res.status(200).send('Verification email sent');
    }
  });
});

app.get('/verify', async (req, res) => {
  const { token } = req.query;
  
  try {
    // Verify and decode JWT token
    const decoded = jwt.verify(token,'email_verify');

    // Extract user data
    const { fullname, email, password } = decoded;

    // Check if email, password, and fullname are present
    if (!email || !password || !fullname) {
      throw new Error('Invalid token data');
    }

    // Hash the password
    if (verificationTokens[token]) {
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const newUser = new User({ fullname, email, password: hashedPassword, authenticationType: 'simple' });
    await newUser.save();
    delete verificationTokens[token];

    res.status(200).json({ message: 'Email verified and user registered successfully' });
  } else {
    // If the token has already been used, return an error
    res.status(400).json({ error: 'Invalid or expired verification token' });
  }
}catch (error) {
    res.status(400).json({ error: 'Invalid or expired verification token' });
  }
});

app.post('/login', async (req, res, next) => {
  try {
    // Validate request body
    const { error } = loginValidationSchema.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }
  
  passport.authenticate('local', (err, user, info) => {
    if (err) {
      return next(err);
    }
    if (!user) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }
    req.logIn(user, (err) => {
      if (err) {
        return next(err);
      }
      if (user.authenticationType === 'google') {
        // Redirect to Google authentication
        console.log('already logged in using google service');
        return res.redirect('/auth/google');
      } else if (user.authenticationType === 'facebook') {
        // Redirect to Facebook authentication
        console.log('already logged in using google service');
        return res.redirect('/auth/facebook');
      } else {
        // Redirect to the protected route
        console.log('already logged in using google service');
        return res.redirect('/protected');
      }
    });
  })(req, res, next);
}catch (err) {
  console.error('Error occurred during login:', err);
  res.status(500).json({ error: 'Internal server error' });
}
});

app.get('/logout', (req, res) => {
  req.logout((err) => {
    if (err) {
      console.error(err);
      return res.sendStatus(500);
    }
    res.clearCookie('auth_token');
    req.session.destroy();
    res.send('Goodbye!');
  });
});

app.get('/auth/facebook', passport.authenticate('facebook', { scope: ['email'] }));

app.get('/auth/facebook/callback',
  passport.authenticate('facebook', { failureRedirect: '/auth/facebook/failure' }),
  (req, res) => {
    // Successful authentication, redirect to protected route or handle as needed
    res.redirect('/protected');
  });

  app.get('/auth/facebook/failure', (req, res) => {
    res.send('Failed to authenticate with Facebook');
  });
  


app.get('/auth/google',
passport.authenticate('google', { scope: ['email', 'profile'] }
));

app.get('/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/auth/google/failure' }),
  async (req, res) => {
    try {
      // Get the access token from the request
      const accessToken = req.user.accessToken;
      console.log('acess token',accessToken);
      // Make a request to the Google People API to fetch user details
      const response = await axios.get('https://www.googleapis.com/oauth2/v3/userinfo', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
        
      // Extract relevant user details from the response
      const userDetails = {
        authenticationType: 'google',
        fullname: response.data.name,
        email: response.data.email,
        // Add more fields as needed
      };
      const existingUser = await User.findOne({ email: userDetails.email, authenticationType: 'google' });
        if (existingUser) {
            const token = jwt.sign({ user: existingUser }, 'your_secret_key');
            res.cookie('auth_token', token, { httpOnly: true, maxAge: 604800000, secure: true });
        } else {
          const existingUserNotGoogle = await User.findOne({ email: userDetails.email})
            if (existingUserNotGoogle) {
              return res.status(400).send('Email is already registered');
            }
            const newUser = new User(userDetails);
            await newUser.save();
            const token = jwt.sign({ user: newUser }, 'your_secret_key');
            res.cookie('auth_token', token, { httpOnly: true, maxAge: 604800000, secure: true });
        }
        res.redirect('/protected');
    } catch (error) {
        console.error('Error fetching user details:', error);
        res.status(500).send('Error fetching user details');
    }
});



app.get('/protected', (req, res) => {
  const token = req.cookies.auth_token;
  console.log(token);
  console.log(req.user);
  if (!req.user){
    return res.status(401).json({ error: 'Unauthorized' });
  }
  
  if (!token && req.user && req.user.authenticationType !== 'simple') {
      return res.status(401).json({ error: 'Unauthorized' });
  }
  
  if (token) {
      jwt.verify(token, 'your_secret_key', async (err, decoded) => {
          if (err) {
              return res.status(401).json({ error: 'Unauthorized' });
          }

          const user = decoded.user;

          if (user.authenticationType === 'google') {
              // Handle Google authentication
              // Add your logic here for Google authentication
              return res.json({ message: `Hello ${user.fullname}, you are logged in via Google` });
          } else if (user.authenticationType === 'facebook') {
              // Handle Simple authentication
              // Add your logic here for Simple authentication
              return res.json({ message: `Hello ${user.fullname}, you are logged in via facebook` });
          } else {
              // Handle other types of authentication
              // Add your logic here for other types of authentication
              return res.json({ message: `Hello ${user.fullname}, you are logged in via ${user.authenticationType}` });
          }
      });
  } else {
      // No token provided, handle local (simple) authentication
      // Add your logic here for local authentication
      return res.json({ message: `hello ${req.user.fullname} ,You are logged in via local authentication` });
  }
});
  
app.get('/auth/google/failure', (req, res) => {
  console.log("failure");
  res.send('Failed to authenticate..');
});
// Create HTTPS server
const options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem'),
  passphrase: 'venusecure'
};

const server = https.createServer(options, app);

// Start the HTTPS server
server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
