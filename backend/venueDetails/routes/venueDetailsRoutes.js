// venueRoutes.js
const express = require('express');
const routerVenueDetailes = express.Router();
const VenueDetails = require('../models/venueDetails');

// POST route to create a new venue
routerVenueDetailes.post('/', async (req, res) => {
  try {
    const {
      venue_id,
      location_id,
      name,
      capacity,
      price,
      availability,
      vendor_id,
      service_category,
      rating_id,
      overall_rating,
      venue_type,
      restriction,
      email_verified,
      contact_verified,
      venue_verified,
      address // Include address from req.body
    } = req.body;

    const newVenue = new VenueDetails({
      venue_id,
      location_id,
      name,
      capacity,
      price,
      availability,
      vendor_id,
      service_category,
      rating_id,
      overall_rating,
      venue_type,
      restriction,
      email_verified,
      contact_verified,
      venue_verified,
      address // Include address in the new venue object
    });

    await newVenue.save();
    res.status(201).json(newVenue);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = routerVenueDetailes;
