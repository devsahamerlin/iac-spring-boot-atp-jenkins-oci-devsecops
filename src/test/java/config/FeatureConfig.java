package config;

import org.devsahamerlin.model.Task;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import java.io.IOException;

public class FeatureConfig {
    public static String URL = "http://localhost:8082";
    public static Task getMockTask() {
        ObjectMapper objectMapper = new ObjectMapper();
        Resource resource = new ClassPathResource("task.json");
        try {
            return objectMapper.readValue(resource.getInputStream(), Task.class);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
