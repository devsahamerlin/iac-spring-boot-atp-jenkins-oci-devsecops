package org.devsahamerlin.repository;

import jakarta.transaction.Transactional;
import org.devsahamerlin.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Repository
@Transactional
@EnableTransactionManagement
public interface TaskRepository extends JpaRepository<Task, String> {
}
