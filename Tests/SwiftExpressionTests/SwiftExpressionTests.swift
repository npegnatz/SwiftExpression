import XCTest
@testable import SwiftExpression

final class SwiftExpressionTests: XCTestCase {
  
  let targetAccuracy = 0.00000001
  
  func testSimpleExpression() {
    XCTAssertEqual(Expression("10 + 2").result(), 12)
    XCTAssertEqual(Expression("2(3)").result(), 6)
    XCTAssertEqual(Expression("2π").result(), 2*Double.pi)
  }
  
  func testComplexExpression() {
    XCTAssertEqual(Expression("7x(2+3)", variables: ["x":3]).result(), 105)
    XCTAssertEqual(Expression("2*x+1", variables: ["x":5]).result(), 11)
  }
  
  func testMathFunctionExpression() {
    XCTAssertEqual(Expression("abs(-10)").result(), 10)
    XCTAssertEqual(Expression("abs(x)", variables: ["x":-7]).result(), 7)
    XCTAssertEqual(Expression("sqrt(4)").result(), 2)
    XCTAssertEqual(Expression("exp(1)").result()!, 2.7182818284, accuracy: targetAccuracy)
  }
  
  func testTrigExpression() {
    XCTAssertEqual(Expression("cos(0)").result(), 1)
    XCTAssertEqual(Expression("sin(π/2)").result(), 1)
    XCTAssertEqual(Expression("2*sin(cos(π))").result()!, -1.68294196962, accuracy: targetAccuracy)
  }
  
  func testValidity() {
    XCTAssertTrue(Expression("abs(x)").isValid())
    XCTAssertTrue(Expression("(32.452*43.234)/(sqrt(10))").isValid())
    
    XCTAssertFalse(Expression("The quick brown fox jumped over the lazy dog").isValid())
    XCTAssertFalse(Expression("🤓").isValid())
    XCTAssertFalse(Expression("22/").isValid())
  }
  
  func testEqualExpressions() {
    XCTAssertEqual(Expression("45+32"), Expression("70+7"))
  }
}
