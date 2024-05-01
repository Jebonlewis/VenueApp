// config.js
const config = {
    port: 443,
    db:{
      dbUrl: 'mongodb://localhost:27017/VenuApp',

    },
    ip: '192.168.0.102',
    register:{
      jwtSecretMail: 'email_verify',
    },
    mail:{
      emailService: 'gmail',
      emailUser: 'hackathonannova@gmail.com',
      emailPass: 'wmrs korv trik gljn',
      userEmailVerificationUrl: `http://192.168.0.102:443/register/verify?token=`, // Updated line
      vendorEmailVerificationUrl: `http://192.168.0.102:443/vendor/register/verify?token=`, // Updated line
      venueEmailVerificationUrl: `http://192.168.0.102:443/venue/register/verify?token=` // Updated line
    },
    google:{
      googleClientId: '437139881682-kqisnb3c0k7to308uacbh7bklvnou9tq.apps.googleusercontent.com',
      googleClientSecret: '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',
      googleCallbackUrl: 'https://localhost:443/auth/google/callback',
      googleApi:'https://people.googleapis.com/v1/people/me',
      jwtSecretGoogle:'google_authentication'
    },
    sessionSecret: 'dogs',
    jwtExpiresIn: '1h',
    jwtSimpleLogin:'simple_login_authentication'
    
  };
  
  module.exports = config;
  