const Joi = require('joi');


const vendorRegisterValidation = Joi.object({
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

    serviceType:Joi.string().valid('Birthday',
    'Music',
    'Wedding',
    'Corporate'),
    email_verified: Joi.boolean().default(true),
    contact_verified: Joi.boolean().default(false),
    active_state: Joi.boolean().default(true),
    authenticationType: Joi.string().valid('google', 'facebook', 'simple').optional(),
    serviceType: Joi.string().required().messages({
        'string.empty': 'serviceType  is required'}),
    

    branchName: Joi.string().default(null),
    aboutBranch: Joi.string().default(null),
    address: Joi.string().default(null),
    city: Joi.string().default(null),
    state: Joi.string().default(null),
    country: Joi.string().default(null),
    location_id: Joi.string().allow(null).default(null),
    serviceCategory: Joi.string().valid('Catering', 'DJ', 'Decorators').allow(null).default(null),
    otp: Joi.number().optional(),
    otpExpires: Joi.date().optional(),

    
  });
  
const vendorLoginValidation = Joi.object({
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
    vendorRegisterValidation,
    vendorLoginValidation
};