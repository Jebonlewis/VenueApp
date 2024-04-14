const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');
const User = require('../models/User'); // Assuming you have a User model defined

passport.use(new LocalStrategy({ usernameField: 'email', passwordField: 'password' },
  function(email, password, done) {
    //console.log(email, password);
    User.findOne({ email: email })
      .then(user => {
        if (!user) { 
          return done(null, false, { message: 'Incorrect email or password' }); }
      
        bcrypt.compare(password, user.password, function(err, result) {
          if (err) {
            return done(err);
          }
          if (!result) {
            console.log('bycrpt')
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


module.exports = passport;