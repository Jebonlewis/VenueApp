const jwt = require('jsonwebtoken');
const config=require('../config/authConfig')
function generateToken(userId, email,fullname,authenticationType,serviceType,userType) {
  console.log(userType)
  return jwt.sign({ userId, email,fullname,authenticationType,serviceType,userType}, config.jwtSimpleLogin, { expiresIn: '1h' });
}

module.exports = { generateToken };
