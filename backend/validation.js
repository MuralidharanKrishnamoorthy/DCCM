const Joi = require('@hapi/joi');

const validateRegister = (data) => {
    const schema = Joi.object({
        Email: Joi.string().email().required(),
        Password: Joi.string().min(6).required(),
        Role: Joi.string().valid('Company', 'Project Developer').required(),
        deviceId: Joi.string().required()
    });
    return schema.validate(data);
};

const validateLogin = (data) => {
    const schema = Joi.object({
        Email: Joi.string().email().required(),
        Password: Joi.string().min(6).required(),
        deviceId: Joi.string().required()
    });
    return schema.validate(data);
};

module.exports = { validateRegister, validateLogin };