'use strict';
module.exports = function(app) {
    let todo = require('../controllers/todoController.js');
    let auth = require('../controllers/authController')

        // todoList Routes
        app.route('/todo')
        .get(auth, todo.listAllAnswers)
        .post(auth, todo.SendAnswer)
        
        app.route('/todo/:id')
        .get(auth, todo.getSingle)
        .patch(auth, todo.update)
        .delete(auth, todo.deleteSingle)
};