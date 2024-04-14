const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth2').Strategy;
const config=require('./authConfig');
const User=require('../models/User');
const axios=require('axios');

// passport.use(new GoogleStrategy({
//     clientID: config.google.googleClientId,
//     clientSecret:config.google.googleClientSecret,
//     callbackURL: 'https://localhost:443/auth/google/callback',
//     passReqToCallback: true,
//     scope:['profile']
//   },
//   async (accessToken, refreshToken, profile, done) => {
//     console.log(profile);

//     profile=await axios.get('/oauth/profile');
//     let user = await User.findOne({ googleId: profile.id });
//     if (!user) {
//       user = await User.create({
//         googleId: profile.id,
//         displayName: profile.displayName,
//         email: profile.emails?.[0].value,
//       });
//     }
//      return done(null, profile);
//  }
// )
// );

passport.use(new GoogleStrategy({
    clientID: config.google.googleClientId,
    clientSecret: config.google.googleClientSecret,
    callbackURL: config.google.googleCallbackUrl,
    passReqToCallback: true,
    scope: ['profile', 'email'],
  },
  async (request, accessToken, refreshToken, profile, done) => {
    try {
      // You can perform additional actions here, such as saving the user to a database
      
      // Fetch user profile using access token
      console.log(accessToken);
      const response = await axios.get(config.google.googleApi, {
        headers: {
          'Authorization': `Bearer ${accessToken}`,
        },
      });
      const userData = response.data;
      console.log(userData);
      // Pass the user data to the done callback
      return done(null, userData);
    } catch (error) {
      return done(error, null);
    }
  }
));

  module.exports =passport;
  