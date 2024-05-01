const Joi = require('joi');


const registerValidationSchema = Joi.object({
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
    contact: Joi.string().optional(),
    gender: Joi.string().optional()
    // contact: Joi.string().optional().regex(/^\d{10}$/).messages({
    //   'string.pattern.base': 'Contact must be a valid 10-digit number'
    // }),
    // gender: Joi.string().valid('male', 'female').optional().messages({
    //   'any.only': 'Gender must be either "male" or "female"'
    // }),
  });
  
const loginValidationSchema = Joi.object({
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
    registerValidationSchema,
    loginValidationSchema
};