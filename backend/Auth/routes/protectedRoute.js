// const express = require('express');
// const routerProtected = express.Router();
// const protectedService = require('../service/ProtectedService');

// routerProtected.get('/', async (req, res) => {
//     try {
//         const result = await protectedService.handleProtectedRequest(req);
//         res.status(200).json(result);
//         console.log('req.user',req.user);
//     } catch (error) {
//         res.status(500).json({ error: 'Internal server error' });
//     }
// });

// module.exports = routerProtected;

const express = require('express');
const routerProtected = express.Router();
const protectedService = require('../service/ProtectedService');

routerProtected.get('/', protectedService.authenticateJWT, (req, res) => {
    const user = req.user;
    console.log('user',user.fullname);
    res.json({ message: `Hello ${user.fullname}, you are authenticated` });
  });

module.exports = routerProtected;