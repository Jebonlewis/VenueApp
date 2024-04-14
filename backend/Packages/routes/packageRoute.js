// packagesRoutes.js
const express = require('express');
const routerPackage = express.Router();
const Packages = require('../models/Package');

// POST route to create a new package
routerPackage.post('/packages', async (req, res) => {
  try {
    const { package_desc, price, type, name, mealType } = req.body;
    const newPackage = new Packages({
      package_desc,
      price,
      type,
      name,
      mealType,
    });
    await newPackage.save();
    res.status(201).json(newPackage);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = routerPackage;
