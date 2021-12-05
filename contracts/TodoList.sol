// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TodoList {
    int256 todoId;
    // uint256 deletedTodoCounter;

    struct Todo {
        int256 id;
        string title;
        bool isCompleted;
    }

    // mapping(uint256 => Todo) public todos;
    Todo[] public todos;

    event AddedTodo(uint256 id, string title, bool isCompleted);

    constructor() {
        todoId = 0;
        // deletedTodoCounter = 0;
        /** 
        todos[0] = Todo(0, "Develop dapp using Flutter", false);
        todos[1] = Todo(1, "Read an article about blockchain", false);
        todoId = 2;
        **/
    }

    function newTodo(string memory title) external {
        // todos[todoId] = Todo(todoId, title, false);
        // emit AddedTodo(todoId - 1, title, false);

        todos.push(Todo(todoId, title, false));
        todoId++;
    }

    function todosCount() external view returns (uint256) {
        // return todoId - deletedTodoCounter;
        return todos.length;
    }

    function toggleIsCompleted(uint256 id) external {
        // todos[id].isCompleted = !todos[id].isCompleted;
        todos[id].isCompleted = !todos[id].isCompleted;
    }

    function deleteTodo(uint256 id) external {
        // delete (todos[id]);
        // delete todos[id];
        todos[id].id = -1;
    }
}
