const mongoose = require('mongoose');
const Vendor= require('../../Auth/models/Vendors');
const Schema = mongoose.Schema;

// Define the Item schema
const ItemSchema = new Schema({
  vendorId: { type: Schema.Types.ObjectId, ref: 'Vendor', required: true },
  itemName: { type: String, required: true },
  aboutItem: { type: String, required: true },
  price: { type: Number, required: true },
  // Assuming you want to store images as URLs
},
{
  timestamps:true,
});

// Create a model based on the schema
const Item = mongoose.model('Item', ItemSchema);

module.exports = Item;
