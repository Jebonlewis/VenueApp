const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const Venue=require('../../Auth/models/venue')
const Location=require('../../location/models/location')
const Vendor=require('../../Auth/models/Vendors')

// Define the VenueDetails schema
const VenueDetailsSchema = new Schema({
  venue_id: { type: Schema.Types.ObjectId, ref: 'Venue', required: true },
  location_id: { type: Schema.Types.ObjectId, ref: 'Location', required: true },
  name: { type: String, required: true },
  capacity: { type: Number, required: true },
  price: { type: Number, required: true },
  availability: { type: Boolean, default: true },
  vendor_id: [{ type: Schema.Types.ObjectId, ref: 'Vendor' }],
  address:{type:String},
  service_category: {
    type: String,
    enum: ['Birthday', 'Music', 'Wedding', 'Corporate'],
    required: true,
  },
  rating_id: { type: String }, // Assuming there's a separate rating document/collection
  overall_rating: { type: Number, min: 1, max: 5 },
  venue_type: { type: String, enum: ['veg', 'nonveg'], required: true },
  restriction: { type: String },
  email_verified: { type: Boolean, default: false },
  contact_verified: { type: Boolean, default: false },
  venue_verified: { type: Boolean, default: false },
  
});

// Create a model based on the schema
const VenueDetails = mongoose.model('VenueDetails', VenueDetailsSchema);

module.exports = VenueDetails;
