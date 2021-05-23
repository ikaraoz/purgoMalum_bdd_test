Feature: Add new word(s) to the profanity list
  optional query parameter: add

  Comma separated
  Letters, numbers, (_), (,) accepted
  Max 10 words or
  Max 200 characters
  Case-insensitive

  @positive @SmokeTest
  Scenario Outline: PurgoMalum adds new unwanted text to profanity list
    Given input text is "<inputText>"
    And "<newUnwantedText>" is not in the profanity list
    When "<newUnwantedText>" is added to the list
    Then status code should be 200
    And result text should be "<expectedText>"
    Examples:
      | newUnwantedText                                                                                                                                                                                          | inputText                                                                                                                                                                                                | expectedText                                                                                                                                                                                             |
      | this                                                                                                                                                                                                     | this                                                                                                                                                                                                     | ****                                                                                                                                                                                                     |
      | This                                                                                                                                                                                                     | this                                                                                                                                                                                                     | ****                                                                                                                                                                                                     |
      | THIS                                                                                                                                                                                                     | this                                                                                                                                                                                                     | ****                                                                                                                                                                                                     |
      | a                                                                                                                                                                                                        | a                                                                                                                                                                                                        | *                                                                                                                                                                                                        |
      | aa                                                                                                                                                                                                       | aa                                                                                                                                                                                                       | **                                                                                                                                                                                                       |
      | a                                                                                                                                                                                                        | a a                                                                                                                                                                                                      | * *                                                                                                                                                                                                      |
      | a_a                                                                                                                                                                                                      | a_a                                                                                                                                                                                                      | *                                                                                                                                                                                                        |
      | a1a                                                                                                                                                                                                      | a1a                                                                                                                                                                                                      | *                                                                                                                                                                                                        |
      | a, b, c, d, e, f, g, h, j, k                                                                                                                                                                             | a b c d e f g h k j                                                                                                                                                                                      | * * * * * * * * * *                                                                                                                                                                                      |
      | twohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyy | twohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyy | ******************************************************************************************************************************************************************************************************** |

  @negative
  Scenario Outline: PurgoMalum unable to add unwanted text to profanity list if the word(s) is invalid
    Given input text is "<inputText>"
    And "<newUnwantedText>" is not in the profanity list
    When "<newUnwantedText>" is added to the list
    Then result text should be "<error>"
    And status code should be 400
    Examples:
      | newUnwantedText                                                                                                                                                                                           | inputText                                                                                                                                                                                                       | error                                      |
      | a, b, c, d, e, f, g, h, j, k, l                                                                                                                                                                           | input a b c d e f g h j k l                                                                                                                                                                                     | User Black List Exceeds Limit of 10 Words. |
      | prof@nity                                                                                                                                                                                                 | input prof@nity                                                                                                                                                                                                 | Invalid Characters in User Black List      |
      | twohundredonecharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryy | input twohundredonecharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryyyytwohundredcharacterlongwordtotestmaximumboundryy | User Black List Exceeds Limit of 10 Words. |

  @positive @safeword @SmokeTest
  Scenario Outline: Safe words are excluded from the filter when new unwanted text is added to profanity list
    Given input text is "<safeWord>"
    And "cla" is not in the profanity list
    When "cla" is added to the list
    Then result text should be "<expectedText>"
    And status code should be 200
    Examples:
      | safeWord      | expectedText  |
      | class         | class         |
      | CLASS         | CLASS         |
      | cl@rk         | cl@rk         |
      | example class | example class |