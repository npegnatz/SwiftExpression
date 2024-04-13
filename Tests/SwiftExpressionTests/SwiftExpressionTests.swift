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
    XCTAssertEqual(Expression("arctan(1)").result() ?? 0, 0.785398163, accuracy: targetAccuracy, Expression("arctan(1)").expressionString)
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
  
  func testOtherExpressions() {
    // Basic arithmetic
    XCTAssertEqual(Expression("1 + 1").result(), 2)
    XCTAssertEqual(Expression("12 - 7").result(), 5)
    XCTAssertEqual(Expression("4 * 5").result(), 20)
    XCTAssertEqual(Expression("20 / 4").result(), 5)
    XCTAssertEqual(Expression("5 ^ 2").result(), 25)
    
    // Combined operations
    XCTAssertEqual(Expression("1 + 2 * 3").result(), 7)
    XCTAssertEqual(Expression("(1 + 2) * 3").result(), 9)
    XCTAssertEqual(Expression("18 / (2 + 4)").result(), 3)
    XCTAssertEqual(Expression("4 * 5 / 2").result(), 10)
    XCTAssertEqual(Expression("3 + 12 / (3 + 1)").result(), 6)
    
    // Functions and constants
    XCTAssertEqual(Expression("ln(\(M_E))").result(), 1)
    XCTAssertEqual(Expression("log(100)").result(), 2)
    
    // Variables and more complex expressions
    XCTAssertEqual(Expression("3x^2 + 5x + 2", variables: ["x": 2]).result(), 24)
    XCTAssertEqual(Expression("y / 3 + 5", variables: ["y": 9]).result(), 8)
    XCTAssertEqual(Expression("2x^2 - 3x + 1", variables: ["x": -1]).result(), 6)
    XCTAssertEqual(Expression("z^2 - 4z + 4", variables: ["z": 2]).result(), 0)
    XCTAssertEqual(Expression("2*sin(π/3)", variables: ["π": Double.pi]).result()!, 1.73205080757, accuracy: targetAccuracy)
  }
}
