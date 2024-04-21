
const express = require('express');
const routerLocation=express.Router();
const serviceLocation=require('../services/locationSearchService');
routerLocation.get("/", async (req, res) => {
    try {
      console.log("Searching nearest locations...");
      const locationRes = await serviceLocation.searchNearestVenue(req.body);
      res.status(201).json(locationRes);
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  });
  
  module.exports = routerLocation;