package org.devsahamerlin.steps;

import config.FeatureConfig;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.devsahamerlin.model.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import static org.junit.jupiter.api.Assertions.assertEquals;
public class AddTaskStep {

    @Autowired
    private TestRestTemplate restTemplate;
    private ResponseEntity<Long> response;
    private Task mockedTask;

    @Given("the user provides valid Task details")
    public void theUserProvidesValidAccountDetails() {
        mockedTask = FeatureConfig.getMockTask();
    }

    @When("the user sends a POST request to {string}")
    public void theUserSendsAPOSTRequestTo(String path) {
        response = this.restTemplate.postForEntity(FeatureConfig.URL + path, mockedTask, Long.class);
    }

    @Then("the response status code of Task registration should be {int}")
    public void theResponseStatusCodeOfTaskAddShouldBe(int statusCode) {
        assertEquals(HttpStatusCode.valueOf(statusCode), response.getStatusCode());
    }

    @And("the response body should contain the created Task ID {string}")
    public void theResponseBodyShouldContainTheCreatedAccountID(String id) {
        assertEquals(id, response.getBody());
    }
}
