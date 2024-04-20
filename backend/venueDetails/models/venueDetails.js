const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const Venue=require('../../Auth/models/venue')
const Location=require('../../location/models/location')
const Vendor=require('../../Auth/models/Vendors')

// Define the VenueDetails schema
const VenueDetailsSchema = new Schema({
  venue_id: { type: Schema.Types.ObjectId, ref: 'Venue', required: true },
  VenueName: { type: String, required: true },
  location_id: { type: Schema.Types.ObjectId, ref: 'Location', required: true },
  hits: { type: Number, default: null, require: true },
  vendor_id: [{ type: Schema.Types.ObjectId, ref: 'Vendor' }],
  
  rating_id: { type: String, default: null }, // Assuming there's a separate rating document/collection
  overall_rating: { type: Number, min: 1, max: 5, default: null },
 
  email_verified: { type: Boolean, default: false },
  contact_verified: { type: Boolean, default: false },
  venue_verified: { type: Boolean, default: false },

  halls: [{
    hotelName: { type: String, required: true },
    aboutName: { type: String, required: true },
    capacity: { type: Number, required: true },
    price: { type: Number, required: true },
    availability: { type: Boolean, default: true },
    address: { type: String, require: true },
 
  service_category: {
    type: String,
    enum: ['Birthday', 'Music', 'Wedding', 'Corporate'],
    required: true,
  },
  venue_type: { type: String, enum: ['veg', 'nonveg'], required: true },
  restriction: { type: String, require: true }
}]
}
,{
  timestamps: true
});

const VenueDetails = mongoose.model('VenueDetails', VenueDetailsSchema);

module.exports = VenueDetails;