import XCTest
@testable import SwiftExpression

final class SwiftExpressionTests: XCTestCase {
  
  func testSimpleExpression() {
    let expression = Expression("10 + 2")
    XCTAssertEqual(expression.result(), 12)
  }
  
  func testInvalidExpression() {
    let expression = Expression("22/")
    XCTAssertEqual(expression.result(), nil)
  }
  
  func testEquality() {
    XCTAssertEqual(Expression("45+32"), Expression("70+7"))
  }
}
