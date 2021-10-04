'use strict';
module.exports = function(app) {
    let todo = require('../controllers/todoController.js');


        // todoList Routes
        app.route('/todo')
        .get(todo.listAllAnswers)
        .post(todo.SendAnswer)
        
        app.route('/todo/:id')
        .get(todo.getSingle)
        .patch(todo.update)
        .delete(todo.deleteSingle)
};