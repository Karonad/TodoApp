'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;


let TodoSchema = new Schema({
    title: {
        type: String
    },
    isCompleted: {
        type: Boolean
    },
    image: {
        type: String
    }
});

module.exports = mongoose.model('Todo', TodoSchema);