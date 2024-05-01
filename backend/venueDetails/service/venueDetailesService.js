const VenueDetails = require('../models/venueDetails'); // Import the VenueDetails model
const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');
const config = require('../../Auth/config/authConfig');

const fs = require('fs');
const multer  = require('multer');
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      // Specify the directory where images will be stored
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      // Generate a unique filename using the document id
      const filename = file.originalname; // You can customize the filename if needed
      cb(null, filename);
    }
  });

async function createHallDetails(hallDetails,File,venue_id) {
    try {
        
        // Find the VenueDetails document by venue_id
        let venueDetails = await VenueDetails.findOne({ venue_id });
        
        if (!venueDetails) {
            // If VenueDetails doesn't exist, create a new one
            venueDetails = new VenueDetails({
                venue_id,
                halls: [hallDetails] // Initialize halls array with the first hallDetails
            });
        } else {
            // If VenueDetails exists, push the new hallDetails into the halls array
            const hallDetail=JSON.parse(hallDetails);
            venueDetails.halls.push(hallDetail);
        }

        // Save the updated VenueDetails document
        const updatedVenueDetails = await venueDetails.save();

        // updatedVenueDetails.halls.forEach(hall => {
        //     const hallId = hall._id.$oid;
        //     const imagePath = `uploads/${hallId}.${File.originalname.split('.').pop()}`;
        //     fs.renameSync(File.path, imagePath);
        // });

        const imagePath = `uploads/${updatedVenueDetails._id}.${File.originalname.split('.').pop()}`;
            fs.renameSync(File.path, imagePath);

        return { success: true, message: 'Hall details and image updated successfully' };
    } catch (error) {
        console.error('Error storing hall details:', error);
        throw error;
    }
}
module.exports = { createHallDetails };
