import _SwiftFormatTestSupport

@_spi(Rules) import SwiftFormat

final class OnlyOneTrailingClosureArgumentTests: LintOrFormatRuleTestCase {
  func testInvalidTrailingClosureCall() {
    assertLint(
      OnlyOneTrailingClosureArgument.self,
      """
      1️⃣callWithBoth(someClosure: {}) {
        // ...
      }
      callWithClosure(someClosure: {})
      callWithTrailingClosure {
        // ...
      }
      """,
      findings: [
        FindingSpec("1️⃣", message: "revise this function call to avoid using both closure arguments and a trailing closure"),
      ]
    )
  }
}
