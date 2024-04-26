const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define the Location schema
const VenueLocationSchema = new Schema({
  venueDetails_id: { type: Schema.Types.ObjectId, ref: 'VenueDetails' }, // Reference to VenueDetails schema
  // latitude: { type: Number, required: true },
  // longitude: { type: Number, required: true }
  location: {
    type: { type: String },
    //[long,lat]
    coordinates: [Number],
  },
});
VenueLocationSchema.index({ location: "2dsphere" });
const VenueLocation = mongoose.model('VenueLocation', VenueLocationSchema);

module.exports = VenueLocation;


