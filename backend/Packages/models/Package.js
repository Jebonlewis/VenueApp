const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define the Packages schema
const PackagesSchema = new Schema({
  package_desc: { type: String, required: true },
  price: { type: Number, required: true },
  type: { type: String, enum: ['standard', 'premium'], default: 'standard' }, 
  name: { type: String, required: true },
  mealType: {
    type: String,
    enum: ['breakfast', 'lunch', 'dinner'],
    required: true,
  },
});

// Create a model based on the schema
const Packages = mongoose.model('Packages', PackagesSchema);

module.exports = Packages;
