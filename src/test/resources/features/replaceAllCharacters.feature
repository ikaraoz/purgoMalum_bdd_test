Feature: Replace all characters in the matching profanity word
  optional query parameter: fill_char

  Fills designated character to length of word replaced.
  Accepts:
  underscore (_)
  tilde (~)
  dash/hyphen (-)
  equal sign (=)
  pipe (|)
  asterisk (*) (default)

  @positive
  Scenario Outline: PurgoMalum returns results in expected return types
    Given input text is "ass"
    And expected return type is "<returnType>"
    When input text is queried
    Then status code should be 200
    And result text should be "***"
    Examples:
      | returnType |
      | xml        |
      | json       |
      | plain      |

  @positive @SmokeTest
  Scenario Outline: PurgoMalum checks if input text is in profanity list
    Given input text is "<inputText>"
    When checked if input is in profanity list
    Then status code should be 200
    And result text should be "<result>"
    Examples:
      | inputText | result |
      | ass       | true   |
      | class     | false  |

  @positive @SmokeTest
  Scenario Outline: PurgoMalum replaces unwanted text from the input text with default special character (*)
    Given input text is "<unwantedText>"
    When input text is queried
    Then status code should be 200
    And result text should be "<expectedText>"
    Examples:
      | unwantedText | expectedText |
      | ass          | ***          |
      | ASS          | ***          |
      | @ss          | ***          |
      | example ass  | example ***  |

  @positive @SmokeTest
  Scenario Outline: PurgoMalum replaces unwanted text from the input text with special characters
    Given input text is "ass"
    When input text is queried with fill_char "<fill_char>"
    Then status code should be 200
    And result text should be "<expectedText>"
    Examples:
      | fill_char | expectedText |
      | _         | ___          |
      | ~         | ~~~          |
      | -         | ---          |
      | =         | ===          |
      | \|        | \|\|\|       |

  @positive @safeword @SmokeTest
  Scenario Outline: PurgoMalum excludes safe words from the filter
    Given input text is "<safeWord>"
    When input text is queried
    Then status code should be 200
    And result text should be "<expectedText>"
    Examples:
      | safeWord      | expectedText  |
      | class         | class         |
      | CLASS         | CLASS         |
      | cl@ss         | cl@ss         |
      | example clas$ | example clas$ |

  @negative
  Scenario Outline: PurgoMalum does not accept special characters for replacement other than designated
    Given input text is "ass"
    When input text is queried with fill_char "<invalid_fill_char>"
    Then result text should be "Invalid User Replacement Characters"
    And status code should be 400
    Examples:
      | invalid_fill_char |
      | ^                 |
      | 1                 |
      | a                 |




