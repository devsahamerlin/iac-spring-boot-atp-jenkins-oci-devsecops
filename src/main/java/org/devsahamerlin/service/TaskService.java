package org.devsahamerlin.service;

import org.devsahamerlin.model.Task;

import java.util.List;

public interface TaskService {
    Task addTask(Task task);
    String deleteTask(String id);
    Task updateTask(Task task);
    List<Task> findTasks();
}
