package config;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import io.cucumber.spring.CucumberContextConfiguration;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;

@CucumberContextConfiguration
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features", glue = "org.devsahamerlin.steps")
@ActiveProfiles("test")
public class CucumberTestRunner {

}
