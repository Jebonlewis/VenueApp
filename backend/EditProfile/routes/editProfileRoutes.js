const { profile } = require('console');
const User = require('../../Auth/models/User');
const express = require('express');
const routerEditProfile = express.Router();
const routerDisplayProfile = express.Router();
const fs = require('fs');
const multer  = require('multer');
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      // Specify the directory where images will be stored
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      // Generate a unique filename using the document id
      const filename = file.originalname; // You can customize the filename if needed
      cb(null, filename);
    }
  });
  const upload = multer({ storage: storage });

routerEditProfile.post('/', upload.single('image'),async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No image file received' });
        }
        console.log("called")
        const {email, ProfileDetails } = req.body;
        const ProfileDetail = JSON.parse(ProfileDetails);
        console.log(ProfileDetail);

        // Find the user by email address
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Update user information in the database
        user.fullname =ProfileDetail.fullName ;
        user.contact = ProfileDetail.contact;
        user.gender = ProfileDetail.gender;
        await user.save();

        const imagePath = `uploads/${user._id}.${req.file.originalname.split('.').pop()}`;
        fs.renameSync(req.file.path, imagePath);

        res.status(200).json({ message: 'User information updated successfully' });
    } catch (error) {
        console.error('Error updating user information:', error);
        if (req.file) {
          fs.unlinkSync(req.file.path);
      }
        res.status(500).json({ error: 'An error occurred while updating user information' });
    }
});

routerDisplayProfile.get('/', async (req, res) => {
  try {
    const email = req.query.email;

    if (!email) {
      return res.status(400).json({ error: 'Email parameter is missing' });
    }

    const user = await User.findOne({ email: email }, '_id');

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const userId = user._id;
    const filename = `${userId}.jpg`; // Assuming the images have a '.jpg' extension
    const imagePath = path.join(__dirname, '..', '..', 'uploads', filename);

    if (!fs.existsSync(imagePath)) {
      return res.status(404).json({ error: 'Image not found' });
    }

    const imageBuffer = fs.readFileSync(imagePath);
    const base64Image = imageBuffer.toString('base64');
    const imageData = { filename: filename, image: base64Image };

    res.json(imageData);
  } catch (error) {
    console.error('Error retrieving images:', error);
    res.status(500).json({ error: 'Failed to retrieve images and item data' });
  }
});


module.exports = {routerEditProfile,
  routerDisplayProfile
};
