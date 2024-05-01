const Joi = require('joi');


const venueRegisterValidation = Joi.object({
    fullname: Joi.string().required().messages({
      'string.empty': 'fullname  is required'}),
    email: Joi.string().email().required().messages({
      'string.email': 'Email must be a valid email address',
      'string.empty': 'email is required'}),
    password: Joi.when('authenticationType', {
      is: Joi.not('google', 'facebook'),
      then: Joi.string().required().min(8).messages({ 
        'string.empty': 'Password is required',
        'any.required': 'Password is required',
        'string.min': 'Password must be at least 8 characters long'
       }),
      otherwise: Joi.string().allow('').optional()
    }),
    confirmPassword: Joi.string().when('authenticationType', {
      is: Joi.not('google', 'facebook'),
      then: Joi.string().valid(Joi.ref('password')).required().messages({ 'any.only': 'Passwords must match' }),
      otherwise: Joi.string().allow('').optional()
    }),
    authenticationType: Joi.string().valid('google', 'facebook', 'simple').optional(),
    otp: Joi.number().optional(),
    otpExpires: Joi.date().optional(),
  });
  
const venueLoginValidation = Joi.object({
    email: Joi.string().email().required().messages({
      'string.email': 'Email must be a valid email address',
      'string.empty': 'email is required'}),
    password: Joi.string().required().min(8).messages({ 
      'string.empty': 'Password is required',
      'any.required': 'Password is required',
      'string.min': 'Password must be at least 8 characters long'
     }),
  });

module.exports = {
    venueRegisterValidation,
    venueLoginValidation
};