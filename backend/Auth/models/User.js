// models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
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
},
{
  timestamps: true, // Add timestamps (createdAt, updatedAt)
}
);

const User = mongoose.model('User', userSchema);
module.exports = User;