const Joi = require('@hapi/joi');


const registervalidate = (data) => {
    const UserSchema = Joi.object({
        Email: Joi.string().email().required(),
        Password: Joi.string().required(),
        Role: Joi.string().valid('Company', 'Project Developer').required()
    });
    return UserSchema.validate(data);
};


const loginvalidate = (data) => {
    const UserSchema = Joi.object({
        Email: Joi.string().email().required(),
        Password: Joi.string().min(6).required()
    });
    return UserSchema.validate(data);
};

module.exports = { registervalidate, loginvalidate };
