import XCTest
@testable import SwiftExpression

final class SwiftExpressionTests: XCTestCase {
  
  func testEvaluateSimpleExpression() {
    let expression = Expression("10 + 2")
    XCTAssertEqual(expression.result(), 12)
  }
  
  func testEvaluateFailure() {
    let expression = Expression("22/")
    XCTAssertEqual(expression.result(), nil)
  }
}
