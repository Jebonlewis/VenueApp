const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define the Location schema
const VenueLocationSchema = new Schema({
  venueDetails: { type: Schema.Types.ObjectId, ref: 'VenueDetails', required: true }, // Reference to VenueDetails schema
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true }
});

const VenueLocation = mongoose.model('VenueLocation', VenueLocationSchema);

module.exports = VenueLocation;
