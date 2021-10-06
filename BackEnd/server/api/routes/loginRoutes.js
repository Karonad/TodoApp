'use strict';
module.exports = function(app) {
    let login = require('../controllers/loginController.js');


        // todoList Routes
        app.route('/login')
        .post(login.login)
        
        app.route('/signup')
        .post(login.signup)
};