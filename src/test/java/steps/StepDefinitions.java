package steps;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;
import io.restassured.specification.*;
import io.restassured.http.*;

import static Base.Constants.*;

import static org.hamcrest.Matchers.*;
import static io.restassured.RestAssured.*;

public class StepDefinitions {
    private RequestSpecification request;
    private Response response;

    @Given("input text is {string}")
    public void inputTextIncludes(String unwantedText) {
        request = given()
                .baseUri(purgoMalumBaseURI)
                .basePath("json")
                .queryParam("text", unwantedText);
    }

    @When("the web service is called")
    public void theWebServiceIsCalled() {
        response = request
                .when()
                .get();
    }

    @Then("status code should be {int}")
    public void statusCodeShouldBe(int statusCode) {
        response
                .then()
                .statusCode(statusCode);
    }

    @And("result text should be {string}")
    public void resultTextShouldBe(String expectedText) {
        response
                .then()
                .log()
                .all()
                .body(containsString(expectedText));
    }

    @And("expected return type is {string}")
    public void expectedReturnTypeIs(String returnType) {
        ContentType contentType;
        switch (returnType) {
            case "xml":
                contentType = ContentType.XML;
                break;
            case "json":
                contentType = ContentType.JSON;
                break;
            case "plain":
                contentType = ContentType.TEXT;
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + returnType);
        }
        request
                .basePath(returnType)
                .accept(contentType)
                .log()
                .all();
    }

    @And("replace text is {string}")
    public void replaceTextIs(String fillText) {
        request
                .queryParam("fill_text", fillText);
    }

    @And("{string} is not in the profanity list")
    public void isNotInTheProfanityList(String newUnwantedText) {
        given()
                .baseUri(purgoMalumBaseURI)
                .basePath("containsprofanity")
                .queryParam("text", newUnwantedText)
                .when()
                .get()
                .then()
                .statusCode(200)
                .body(equalTo("false"));
    }

    @When("{string} is added to the list")
    public void isAddedToTheList(String newUnwantedText) {
        response = request
                .queryParam("add", newUnwantedText).log().all()
                .when()
                .get();
    }

    @When("checked if input is in profanity list")
    public void checkedIfInputIsInProfanityList() {
        response = request
                .basePath("containsprofanity")
                .log()
                .all()
                .when()
                .get();
    }

    @When("input text is queried with fill_text {string}")
    public void inputTextIsQueriedWithFill_text(String replaceText) {
        response = request
                .queryParam("fill_text", replaceText)
                .when()
                .get();
    }

    @When("input text is queried")
    public void inputTextIsQueried() {
        response = request
                .when()
                .get();
    }

    @When("input text is queried with fill_char {string}")
    public void inputTextIsQueriedWithFill_char(String fillChar) {
        response = request
                .queryParam("fill_char", fillChar)
                .when()
                .get();
    }

    @And("word {string} is in the profanity list")
    public void wordIsInTheProfanityList(String replaceText) {
        given()
                .baseUri(purgoMalumBaseURI)
                .basePath("containsprofanity")
                .queryParam("text", replaceText)
                .when()
                .get()
                .then()
                .statusCode(200)
                .body(equalTo("true"));
    }
}
