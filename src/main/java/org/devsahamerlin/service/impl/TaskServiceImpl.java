package org.devsahamerlin.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.devsahamerlin.model.Task;
import org.devsahamerlin.repository.TaskRepository;
import org.devsahamerlin.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Slf4j
public class TaskServiceImpl implements TaskService {
    @Autowired
    private TaskRepository taskRepository;
    @Override
    public Task addTask(Task task) {
        task.setID(UUID.randomUUID().toString());
        log.info("New task created!");
        return taskRepository.save(task);
    }

    @Override
    public String deleteTask(String id) {
        Optional<Task> task = taskRepository.findById(id);
        if (task.isEmpty()) {
            log.info("Tasks with id {} don't exist", id);
            return "Tasks with id " +id+ " don't exist";
        }
        log.info("Task {} successfully deleted", id);
        taskRepository.deleteById(id);
        return "Task successfully deleted";
    }

    @Override
    public Task updateTask(Task task) {
        Optional<Task> optionalTask = taskRepository.findById(task.getID());
        if (optionalTask.isEmpty()){
            log.info("Tasks {} don't exist", task.getID());
            throw new RuntimeException("Tasks id " +task.getID()+ " don't exist");
        }
        return taskRepository.save(task);
    }

    @Override
    public List<Task> findTasks() {
        return taskRepository.findAll();
    }
}
