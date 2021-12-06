// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TodoList {
    int256 todoId;

    struct Todo {
        int256 id;
        string title;
        bool isCompleted;
    }

    mapping(address => Todo[]) public todos;

    event AddedTodo(uint256 id, string title, bool isCompleted);

    constructor() {
        todoId = 0;
    }

    function newTodo(address add, string memory title) external {
        todos[add].push(Todo(todoId, title, false));
        todoId++;
    }

    function todosCount(address add) external view returns (uint256) {
        return todos[add].length;
    }

    function toggleIsCompleted(address add, uint256 id) external {
        todos[add][id].isCompleted = !todos[add][id].isCompleted;
    }

    function deleteTodo(address add, uint256 tdId) external {
        todos[add][tdId].id = -1;
    }
}
