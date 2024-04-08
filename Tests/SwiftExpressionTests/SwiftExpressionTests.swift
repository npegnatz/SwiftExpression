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
  
  func testVariableExpression() {
    let expression = Expression("2*x+1", variables: ["x":5])
    XCTAssertEqual(expression.result(), 11)
  }
  
  func testAbsoluteValue() {
    let expression = Expression("abs(x)", variables: ["x":-7])
    XCTAssertEqual(expression.result(), 7)
  }
  
  func testEqualExpressions() {
    XCTAssertEqual(Expression("45+32"), Expression("70+7"))
  }
}
