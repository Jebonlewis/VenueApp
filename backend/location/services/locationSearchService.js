
const VenueDetails = require("../../venueDetails/models/venueDetails");
const Location = require("../models/venueLocation");

async function searchNearestVenue(locationData) {
  try {
    const { longitude, latitude } = locationData;
    const givenPoint = [longitude, latitude];
    const res = await Location.find({
      location: {
        $near: {
          $geometry: { type: "Point", coordinates: givenPoint },
          $minDistance: 1000,
          $maxDistance: 10000,
        },
      },
    });
    const venueDetailsId = res[0].venueDetails_id;
    const result=await VenueDetails.findById(venueDetailsId);
    console.log("Output" + result);
    return res;
  } catch (err) {
    console.log("Failed to find due to following error: %s", err.message);
  }
}

module.exports = {
  searchNearestVenue,
};