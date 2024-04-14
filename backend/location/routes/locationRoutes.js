const express = require('express');
const Location=require('../models/location');
const routerLocation=express.Router();

routerLocation.post('/',async(req,res)=>{
    try {
        const { name, city, state, country, latitude, longitude } = req.body;
        const newLocation = new Location({
          name,
          city,
          state,
          country,
          latitude,
          longitude,
        });
        await newLocation.save();
        res.status(201).json(newLocation);
      } catch (err) {
        res.status(400).json({ message: err.message });
      }
    });
    
module.exports = routerLocation;