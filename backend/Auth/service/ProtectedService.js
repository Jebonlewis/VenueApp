// ;const jwt = require('jsonwebtoken');
// const config = require('../config/authConfig');

// async function handleProtectedRequest(req) {
//     const token = req.cookies.auth_token;
//     console.log(req.user);
//     if (!req.user){
//         console.log('1')
//         return { error: 'Unauthorized' };
//       }
      
//       if (!token && req.user && req.user.authenticationType !== 'simple') {
//         console.log('2')
//         return { error: 'Unauthorized' };
//       }

//     try {
//         if (token) {
//             const decoded=jwt.verify(token, config.jwtSecretProtected);
      
//                 const user = decoded.user;
      
//                 if (user.authenticationType === 'google') {
//                     return { message: `Hello ${user.fullname}, you are logged in via Google` };
//                 } else if (user.authenticationType === 'facebook') {
//                     return { message: `Hello ${user.fullname}, you are logged in via facebook` };
//                 } else {
//                     return { message: `Hello ${user.fullname}, you are logged in via ${user.authenticationType}` };
//                 }
            
//         } else {
//             return { message: `hello ${req.user.fullname} ,You are logged in via local authentication` };
//         }
//     } catch (error) {
//         console.log('3')
//         return { error: error.message };
// }
// }
// module.exports = {
//     handleProtectedRequest
// };



//const { verifyToken } = require('../service/authSimpleLoginService');
const config=require('../config/authConfig');
const jwt=require('jsonwebtoken');


function authenticateJWT(req, res, next) {
  console.log("called protected");
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  console.log('token', token)

  if (token == null) {
      return res.sendStatus(401);
  }

  try {
      const user = jwt.verify(token, config.jwtSimpleLogin);
      console.log(user);
      console.log(user.fullname);
      console.log(user.authenticationType);
      if (user.authenticationType === 'google') {
          const decodedGoogle = jwt.verify(token, config.google.jwtSecretGoogle);
          req.user = decodedGoogle.user;
          return next(); // Proceed to the next middleware or route handler
      } else {
          req.user = user;
          return next(); // Proceed to the next middleware or route handler
      }
  } catch (error) {
      console.error('JWT verification failed:', error);
      return res.sendStatus(403);
  }
}

module.exports = { authenticateJWT };