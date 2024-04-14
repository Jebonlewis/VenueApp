const mongoose = require('mongoose');

const branchSchema = new mongoose.Schema({
  branchName: {
    type: String,
    required: true
  },
  aboutBranch: String,
  city: {
    type: String,
    required: true
  },
  state: {
    type: String,
    required: true
  },
  country: {
    type: String,
    required: true
  },
  imageURL: String, // Assuming you store image URLs
  // Other fields you might need, e.g., contact details, location coordinates, etc.
},
{
  timestamps: true, // Add timestamps (createdAt, updatedAt)
});

const Branch = mongoose.model('Branch', branchSchema);
module.exports = Branch;