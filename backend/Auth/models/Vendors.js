// const mongoose = require('mongoose');

// const vendorSchema = new mongoose.Schema({
//   fullname: String,
//   email: String,
//   password: String,
//   authenticationType: {
//     type: String,
//     enum: ['google', 'facebook', 'simple']
//   },
//   email_verified: {
//     type: Boolean,
//     default: true, // Default value for email_verified is true
//   },
//   contact_verified: {
//     type: Boolean,
//     default: false, // Default value for contact_verified is false
//   },
//   active_state: {
//     type: Boolean,
//     default: true, // Default value for active_state is true
//   },
//   serviceType:String,
//   branchName: String,
//   aboutBranch: String,
//   address: String,
//   city: String,
//   state: String,
//   country: String
// },
// {
//   timestamps: true, // Add timestamps (createdAt, updatedAt)
// }
// );

// const Vendor = mongoose.model('Vendor', vendorSchema);
// module.exports = Vendor;


const { string } = require('joi');
const mongoose = require('mongoose');

const vendorSchema = new mongoose.Schema({
  fullname: String,
  email: String,
  password: String,
  authenticationType: {
      type: String,
      enum: ['google', 'facebook', 'simple']
  },
  email_verified: {
      type: Boolean,
      default: true
  },
  contact_verified: {
      type: Boolean,
      default: false
  },
  active_state: {
      type: Boolean,
      default: true
  },
  serviceType: {
   type:String,
   enum:[ 'Birthday',
  'Music',
  'Wedding',
  'Corporate',]
},
  branchName: {
      type: String,
      default: null
  },
  aboutBranch: {
      type: String,
      default: null
  },
  address: {
      type: String,
      default: null
  },
  city: {
      type: String,
      default: null
  },
  state: {
      type: String,
      default: null
  },
  country: {
      type: String,
      default: null
  },
  location_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'VendorLocation' ,
      default:null// Reference to VendorLocationSchema
  },
  serviceCategory: {
      type: String,
      enum: [
        'Caterer',
        'Sounds',
        'Decorator',
        // Add more cities as needed
      ],
      default:null
  }
}, {
  timestamps: true
});

const Vendor = mongoose.model('Vendor', vendorSchema);
module.exports = Vendor;
