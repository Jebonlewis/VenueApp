// mongoDB.js
const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');
const config = require('./authConfig');

const connPromise = mongoose.connect(config.db.dbUrl);

// Wait for the connection to be established
const gfsVendorImagePromise = connPromise.then((conn) => {
    // Connection established, initialize GridFSBucket for vendor service
    return new GridFSBucket(conn.connection.db, {
        bucketName: 'vendorimage' // Bucket name for vendor service
    });
}).catch((err) => {
    // Handle connection errors
    console.error('Error connecting to MongoDB:', err);
});

const gfsVendorItemImagePromise = connPromise.then((conn) => {
    // Connection established, initialize GridFSBucket for item service
    return new GridFSBucket(conn.connection.db, {
        bucketName: 'vendorItemImage' // Bucket name for item service
    });
}).catch((err) => {
    // Handle connection errors
    console.error('Error connecting to MongoDB:', err);
});

// Export connPromise, gfsVendorImagePromise, and gfsVendorItemImagePromise
module.exports = {
    connPromise,
    gfsVendorImagePromise,
    gfsVendorItemImagePromise
};
