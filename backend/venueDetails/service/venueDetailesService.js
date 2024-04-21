const VenueDetails = require('../models/venueDetails'); // Import the VenueDetails model
const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');
const config = require('../../Auth/config/authConfig');

async function createHallDetails(hallDetails, imageFile, venue_id) {
    try {
        await mongoose.connect(config.db.dbUrl);

        // Once connected, initialize GridFSBucket
        const gfs = new GridFSBucket(mongoose.connection.db, {
            bucketName: 'venueHallImages'
        });

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

        // If an image file is provided, store it in GridFS
        const writeStream = gfs.openUploadStream(imageFile.originalname, {
            metadata: { venueDetails_id:updatedVenueDetails._id,halls_id:updatedVenueDetails.halls[updatedVenueDetails.halls.length - 1]._id  }            
        });

        writeStream.write(imageFile.buffer);
        writeStream.end();

        return { success: true, message: 'Hall details and image updated successfully' };
    } catch (error) {
        console.error('Error storing hall details:', error);
        throw error;
    }
}
module.exports = { createHallDetails };
