// models/User.js
const { number } = require('joi');
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
  otp:{
    type:Number,
    default: null,
  },
  otpExpires: {
    type: Date,
    default: null,
  },
  contact: {
  type:String,
  default:null
  } ,// New field for contact
  gender: {
    type: String,
    enum: ['male', 'female'],
    lowercase: true,
    default:null // Ensure the values are stored in lowercase
  },
},
{
  timestamps: true, // Add timestamps (createdAt, updatedAt)
}
);

const User = mongoose.model('User', userSchema);
module.exports = User;