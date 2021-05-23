Feature: Replace text as whole with given character(s)
  optional query parameter: fill_text

  Accepts:
  letters
  numbers
  underscore (_)
  tilde (~)
  exclamation points (!)
  dash/hyphen (-)
  equal sign (=)
  pipe (|)
  single quotes (')
  double quotes (")
  open and closed curly brackets ({ })
  square brackets ([ ])
  parentheses ()
  asterisk (*) (default)
  Maximum length is 20 characters

  @positive @SmokeTest
  Scenario Outline: PurgoMalum replaces unwanted text with given character(s)
    Given input text is "example wiseass"
    When input text is queried with fill_text "<fill_text>"
    Then status code should be 200
    And result text should be "<expectedText>"
    Examples:
      | fill_text            | expectedText         |
      | _~!-='{}[]()         | _~!-='{}[]()         |
      | \"                   | \"                   |
      | a                    | a                    |
      | 1                    | 1                    |
      | 20CharLongReplacemen | 20CharLongReplacemen |

  @negative
  Scenario: PurgoMalum unable to replace unwanted text if given word is already a profanity word
    Given input text is "example ass"
    And word "wiseass" is in the profanity list
    When input text is queried with fill_text "wiseass"
    Then result text should be "Invalid User Replacement Text"

  @negative
  Scenario Outline: PurgoMalum unable to replace unwanted text if given character(s) is not valid
    Given input text is "example wiseass"
    When input text is queried with fill_text "<invalid_fill_text>"
    Then result text should be "<errorMessage>"
    And status code should be 400
    Examples:
      | invalid_fill_text     | errorMessage                                          |
      | 21CharLongReplacement | User Replacement Text Exceeds Limit of 20 Characters. |
      | ^                     | Invalid User Replacement Text                         |



