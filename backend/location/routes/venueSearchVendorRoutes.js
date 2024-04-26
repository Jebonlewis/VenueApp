
const express = require('express');
const routerVenueSearchVendor=express.Router();
const serviceLocation=require('../services/locationSearchService');
const Vendor = require('../../Auth/models/Vendors');
const Venue = require('../../Auth/models/venue');
const VenueLocation = require('../models/venueLocation');
const VenueDetails = require('../../venueDetails/models/venueDetails');
const vendorLocation = require('../models/vendorLocation');
//const VenueLocation = require('../models/venueLocation');
routerVenueSearchVendor.get("/", async (req, res) => {
    try {
        console.log("searching")
        const {email}=req.body;
        const venue = await Venue.findOne({ email });
        console.log(venue._id);
        const venueDetails=await VenueDetails.findOne({venue_id:venue._id});
        console.log(venueDetails._id);
        if (!venue) {
            throw new Error('venue not found');
        }
    
    const venueLocation = await VenueLocation.findOne({venueDetails_id:venueDetails._id });
    console.log(venueLocation);

    if (!venueLocation) {
        throw new Error('Vendor location not found');
    }

    // Extract latitude and longitude from the location
    const { coordinates } = venueLocation.location;
    const latitude = coordinates[1];
    const longitude = coordinates[0];

    // Now you have latitude and longitude

    console.log("Latitude:", latitude);
    console.log("Longitude:", longitude);
        // Extract latitude and longitude from the location
      //const locationRes = await serviceLocation.searchNearestVenue();
      const givenPoint = [longitude, latitude];
      const result = await vendorLocation.find({
        location: {
          $near: {
            $geometry: { type: "Point", coordinates: givenPoint },
            $minDistance: 1,
            $maxDistance: 500000,
          },
        },
      });
    console.log("result",result);
    //   const venueDetailsId = res[0].venueDetails_id;
    //   const result=await VenueDetails.findById(venueDetailsId);
    //   console.log("Output" + result);
    //   return res;


    res.status(201).json("suceess");
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  });
  
  module.exports = routerVenueSearchVendor;