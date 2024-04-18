package org.devsahamerlin.controller;

import org.devsahamerlin.model.Task;
import org.devsahamerlin.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class TaskRestController {
    @Autowired
    private TaskService taskService;

    @PostMapping("/tasks")
    public ResponseEntity<Task> addTask(@RequestBody Task task) {
        return ResponseEntity.ok(taskService.addTask(task));
    }

    @PutMapping("/tasks")
    public ResponseEntity<Task> updateTask(@RequestBody Task task) {
        return ResponseEntity.ok(taskService.updateTask(task));
    }

    @DeleteMapping("/tasks/{id}")
    public ResponseEntity<String> addTask(@PathVariable String id) {
        return ResponseEntity.ok(taskService.deleteTask(id));
    }

    @GetMapping("/tasks")
    public ResponseEntity<List<Task>> getAllTasks() {
        return ResponseEntity.ok(taskService.findTasks());
    }

    @GetMapping("/")
    public String hello() {
        return "Hello app!";
    }
}
