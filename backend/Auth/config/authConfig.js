// config.js
const config = {
    port: 443,
    db:{
      dbUrl: 'mongodb://localhost:27017/VenuApp',

    },
    register:{
      jwtSecretMail: 'email_verify',
    },
    mail:{
      emailService: 'gmail',
      emailUser: 'hackathonannova@gmail.com',
      emailPass: 'wmrs korv trik gljn',
      userEmailVerificationUrl: 'https://192.168.0.102:443/register/verify?token=',
      vendorEmailVerificationUrl: 'https://192.168.0.102:443/vendor/register/verify?token=',
      venueEmailVerificationUrl: 'https://192.168.0.102:443/venue/register/verify?token='
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
  