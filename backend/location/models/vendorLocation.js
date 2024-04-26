const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const VendorLocationSchema = new Schema({
    vendorDetails_id: { type: Schema.Types.ObjectId, ref: 'Vendor' }, // Reference to VenueDetails schema
    // latitude: { type: Number, required: true },
    // longitude: { type: Number, required: true }
    location: {
      type: { type: String },
      //[long,lat]
      coordinates: [Number],
    },
  });
  VendorLocationSchema.index({ location: "2dsphere" });
  const vendorLocation = mongoose.model('vendorLocation', VendorLocationSchema);
  
  module.exports = vendorLocation;