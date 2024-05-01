// models/User.js
const mongoose = require('mongoose');

const venueSchema = new mongoose.Schema({
  fullname: String,
  email: String,
  password: String,
  authenticationType: {
    type: String,
    enum: ['google', 'facebook', 'simple']
  }, 
  email_verified: {
    type: Boolean,
    default: true, // Default value for email_verified is true
  },
  contact_verified: {
    type: Boolean,
    default: false, // Default value for contact_verified is false
  },
  active_state: {
    type: Boolean,
    default: true, // Default value for active_state is true
  },
  otp:{
    type:Number,
    default: null,
  },
  otpExpires: {
    type: Date,
    default: null,
  },
},
{
  timestamps: true, // Add timestamps (createdAt, updatedAt)
}
);

const Venue = mongoose.model('Venue', venueSchema);
module.exports = Venue;