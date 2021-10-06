'use strict';


let todoRepo = require('../repository/todoRepository.js');
let mongoose = require('mongoose'),
    Todo = mongoose.model('Todo');

exports.listAllAnswers = function(req, res) {
    Todo.find({}, function(err, task) {
        if (err)
            res.send(err);
        res.json(task);
    });
};

exports.SendAnswer = function(req, res) {
    let newTodo = new Todo(req.body);
    console.log(newTodo);
    newTodo.save(function(err, task) {
        if (err)
            res.send(err);
        res.json(task);
    });
};
exports.getSingle = function(req, res) {
    Todo.findById(req.params.id, function (err, todo) {
        if (err) return res.status(500).send("There was a problem finding the user.");
        if (!todo) return res.status(404).send("No todo found.");
        res.status(200).send(user);
    });
};

exports.update = function(req, res) {
    Todo.findByIdAndUpdate(req.params.id, req.body, {new: true}, function (err, user) {
        if (err) return res.status(500).send("There was a problem updating the todo.");
        res.status(200).send(user);
    });
};
exports.deleteSingle = function(req, res) {
    Todo.findByIdAndRemove(req.params.id, function (err, todo) {
        if (err) return res.status(500).send("There was a problem deleting the todo.");
        res.status(200).send("Todo: "+ todo.title +" was deleted.");
    });
};