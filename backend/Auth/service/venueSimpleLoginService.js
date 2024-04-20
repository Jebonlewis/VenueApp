const jwt = require('jsonwebtoken');
const config=require('../config/authConfig')
function generateToken(userId, email,fullname,authenticationType,userType) {
  console.log(userType)
  return jwt.sign({ userId, email,fullname,authenticationType,userType}, config.jwtSimpleLogin, { expiresIn: '1h' });
}

module.exports = { generateToken };
