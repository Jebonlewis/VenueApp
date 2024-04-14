const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Define the Location schema
const LocationSchema = new Schema({
  //location_id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  city: { type: String, required: true },
  state: { type: String, required: true },
  country: { type: String, required: true },
  latitude: { type: Number, required: true },
  longitude: { type: Number, required: true },
}
);

// Create a model based on the schema
const Location = mongoose.model('Location', LocationSchema);

module.exports = Location;
