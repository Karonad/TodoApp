'use strict';
let mongoose = require('mongoose');
let Schema = mongoose.Schema;


let TodoSchema = new Schema({
    title: {
        type: String
    },
    isCompleted: {
        type: Boolean
    }
});

module.exports = mongoose.model('Todo', TodoSchema);