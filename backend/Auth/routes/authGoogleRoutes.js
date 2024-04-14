const express = require('express');
//const passport = require('passport');
const routerGoogle = express.Router();
//const cors=require('cors');
const authService = require('../service/authGoogleService');
const googlePassport=require('../config/authGooglePassport');
const config=require('../config/authConfig')
const axios=require('axios');

routerGoogle.get('/auth/google', googlePassport.authenticate('google',{scope:['email','profile']}));
  
  // Google OAuth callback route
routerGoogle.get('/auth/google/callback', googlePassport.authenticate('google', { failureRedirect: '/login' }), async(req, res) => {
    console.log("working");
    res.redirect('/oauth/google');
    // try {
    //             console.log('callback');
    //             const userDetails = await authService.processGoogleCallback(req.user);
    //             const tokenOrError = await authService.generateAuthToken(userDetails);
    //             if (tokenOrError.error) {
    //                 res.status(400).send(tokenOrError.error);
    //             } else {
                    
    //                 res.status(200).send({ token: tokenOrError}); 
                    
    //             }
    //         } catch (error) {
    //             console.error('Error processing Google callback:', error);
    //             res.status(500).send('Error processing Google callback');
    //         }
    res.redirect('/profile');
         });
   
routerGoogle.get('/oauth/google',async(req,res)=>{
    const {code}=req.querry;
    console.log(code);
    try {
        const response = await axios.post('https://oauth2.googleapis.com/token', {
          code,
          client_id: config.google.googleClientId,
          client_secret: config.google.googleClientSecret,
          redirect_uri: config.google.googleCallbackUrl,
          grant_type: 'authorization_code',
        });
        const {access_token}=response.data;
        console.log(access_token);
        const profile= await axios.get(config.google.googleApi, {
            headers: {
                'Authorization': `Bearer ${accessToken}`
            }
       
        }
        
        );
        console.log(profile);
        const data=profile.data;
        

        return res.status(200).send({ data });
    }
   
   catch (error) {
    console.error('Error exchanging authorization code:', error.response.data);
    return res.status(500).send('Error exchanging authorization code');
  }
});

routerGoogle.get('/profile',(req,res)=>{
    if(req.isAuthenticated){
        res.send(`is auntheicated",${req.user.displayName}`)
    }
    else{
        res.redirect('/auth/google');
    }
})
    

// routerGoogle.get('/auth/google', googlePassport.authenticate('google', { scope: ['email', 'profile'] }));

// routerGoogle.get('/auth/google/callback', googlePassport.authenticate('google', { failureRedirect: '/auth/google/failure' }), async (req, res) => {
//     try {
//         console.log('callback');
//         const userDetails = await authService.processGoogleCallback(req.user);
//         const tokenOrError = await authService.generateAuthToken(userDetails);
//         if (tokenOrError.error) {
//             res.status(400).send(tokenOrError.error);
//         } else {
            
            
//             res.redirect('https://localhost:5173/'); 
            
//         }
//     } catch (error) {
//         console.error('Error processing Google callback:', error);
//         res.status(500).send('Error processing Google callback');
//     }
// });

// routerGoogle.get('/auth/google', async (req, res) => {
//     try {
//         console.log("working");
//       const response = await axios.get('https://accounts.google.com/o/oauth2/v2/auth', {
//         params: {
//           response_type: 'code',
//           redirect_uri: 'https://localhost:443/auth/google/callback',
//           scope: 'email profile',
//           client_id: config.google.googleClientId,
//           client_secret: config.google.googleClientSecret,
//         },
//       });
//       //console.log(response.data);
//       res.json(response.data);
//     } catch (error) {
//       res.status(500).json({ error: 'Error occurred during Google login' });
//     }
//   });

//   routerGoogle.get('/auth/google/callback', async (req, res) => {
//     try {
//       const code = req.query.code;
//       const tokenResponse = await axios.post('https://oauth2.googleapis.com/token', {
//         code: code,
//         client_id: config.google.googleClientId,
//         client_secret: config.google.googleClientSecret,
//         redirect_uri: 'https://localhost:443/auth/google/callback',
//         grant_type: 'authorization_code',
//       });
//       // Handle tokenResponse as needed (e.g., save tokens, get user info)
//       console.log(tokenResponse.data)
//       res.json(tokenResponse.data);
//     } catch (error) {
//       console.error('Error processing Google OAuth callback:', error);
//       res.status(500).send('Error processing Google OAuth callback');
//     }
//   });

module.exports = routerGoogle;
