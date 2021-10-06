'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;


let UserSchema = new Schema({
    username: {
        type: String
    },
    password: {
        type: String
    },
    token: {
        type: String
    },
});

module.exports = mongoose.model('User', UserSchema);