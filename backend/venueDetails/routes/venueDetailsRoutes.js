const express = require('express');
const VenueDetails = require("../models/venueDetails");
const Venue = require('../../Auth/models/venue');
const VenueLocation = require('../../location/models/venueLocation');
const routerNoofHalls = express.Router();
const routerHallDetails = express.Router();
const multer  = require('multer');
const venueService=require('../service/venueDetailesService');

const storage = multer.memoryStorage(); // Store files in memory

// Initialize multer with the defined storage
const upload = multer({ storage: storage, limits: { fileSize: 80 * 1024 * 1024 } });

routerNoofHalls.post('/', async (req, res) => {
  let savedVenueLocation; // Declare variable to hold saved VenueLocation
  try {
    const { email, VenueName, latitude, longitude, address, country, state, city } = req.body;
    const venue = await Venue.findOne({ email: email }, '_id');
    const venue_id = venue._id;
    const existingVenue = await VenueDetails.findOne({venue_id });
    if (existingVenue){
      console.log('venue already exist');
      res.status(500).json({ message: 'venue already exist' });
    }
    else{

    // Find the venue based on email
    
    const location = {
      type: "Point",
      coordinates: [longitude, latitude],
    }
    // Create a new VenueLocation document
    const newVenueLocation = new VenueLocation({
      location
    });

    // Save the VenueLocation document to the database
    savedVenueLocation = await newVenueLocation.save();

    // Get the ObjectId of the saved VenueLocation
    const location_id = savedVenueLocation._id;

    // Get the ObjectId of the venue
    

    // Create a new VenueDetails document
    const newVenueDetails = new VenueDetails({
      venue_id,
      VenueName,
      location_id,
      address,
      country,
      state,
      city
    });

    // Save the VenueDetails document to the database
    const savedVenueDetails = await newVenueDetails.save();

    // Update the associated VenueLocation with the ObjectId of the saved VenueDetails
    await VenueLocation.findByIdAndUpdate(location_id, { venueDetails_id: savedVenueDetails._id });

    res.status(201).json({ message: 'Venue details stored successfully' });
  } 
}
catch (error) {
    console.error(error);
    // If there's an error, delete the associated VenueLocation
    if (savedVenueLocation) {
      await VenueLocation.findByIdAndDelete(savedVenueLocation._id);
    }
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

routerHallDetails.post('/',upload.single('image') , async (req, res) => {
  try {
    console.log("called hall");
    if (req.file) {
      console.log("imageFile:", req.file);
      const imageFile = {
          // buffer: fs.readFileSync(req.file.path), // Read file contents
          // originalname: req.file.originalname // Retain original name
          buffer: req.file.buffer, // Access the file buffer directly
          originalname: req.file.originalname 
      };
  
    const {
      email,
      hallDetails
    } = req.body;

    const venue = await Venue.findOne({ email: email }, '_id');
    const venue_id = venue._id;

    // Find the VenueDetails document by venue_id
    const venueDetails = await VenueDetails.findOne({ venue_id });

    if (!venueDetails) {
      return res.status(404).json({ message: "Venue details not found" });
    }
    const newItem = await venueService.createHallDetails(hallDetails,imageFile,venue_id);
    // Add hall details to the existing VenueDetails document
    

    // Save the updated VenueDetails document
    const updatedVenueDetails = await venueDetails.save();

    res.status(201).json({ message: 'Added hall details successfully' });// Send the updated VenueDetails as response
  }
  else {
      console.log("No imageFile received");
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});



module.exports = {routerNoofHalls,
                 routerHallDetails
                }

// router.post('/venueDetails', async (req, res) => {
//   try {
    
//     const {
//       venue_id,
//       VenueName,
//       location_id,
//       hits,
//       vendor_id,
//       rating_id,
//       overall_rating,
//       email_verified,
//       contact_verified,
//       venue_verified,
//       halls
//     } = req.body;

//     // Create a new VenueDetails document
//     const newVenueDetails = new VenueDetails({
//       venue_id,
//       VenueName,
//       location_id,
//       hits,
//       vendor_id,
//       rating_id,
//       overall_rating,
//       email_verified,
//       contact_verified,
//       venue_verified,
//       halls
//     });

//     // Save the VenueDetails document to the database
//     const savedVenueDetails = await newVenueDetails.save();

//     res.status(201).json(savedVenueDetails); // Send the saved VenueDetails as response
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'Internal Server Error' });
//   }
// });

