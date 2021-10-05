"use strict";
module.exports = function (app) {
  let todo = require("../controllers/todoController.js");
  const storage = require("../helpers/storage");

  // todoList Routes
  app.route("/todo")
    .get(todo.listAllAnswers)
    .post(storage, todo.SendAnswer);

  app.route("/todo/:id")
    .get(todo.getSingle)
    .patch(todo.update)
    .delete(todo.deleteSingle);
};
