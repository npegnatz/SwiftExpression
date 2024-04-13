import XCTest
@testable import SwiftExpression

final class SwiftExpressionTests: XCTestCase {
  
  let targetAccuracy = 0.000000001
  
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
    XCTAssertEqual(Expression("2*sin(π/3)").result()!, 1.73205080757, accuracy: targetAccuracy)
    
    // Advanced mathematical functions
    XCTAssertEqual(Expression("cos(2 * π)").result(), 1)
    XCTAssertEqual(Expression("tan(π / 4)").result()!, 1, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("sin(π / 6)").result()!, 0.5, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("sqrt(81)").result(), 9)
    XCTAssertEqual(Expression("cbrt(27)").result(), 3)

    XCTAssertEqual(Expression("exp(2)").result()!, 7.38905609893, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("3^3").result(), 27)
    XCTAssertEqual(Expression("log(\(M_E)^2)").result()!, 0.8685889638, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("log(1000)").result(), 3)
    
    XCTAssertEqual(Expression("3x^3 - 2x^2 + x - 1", variables: ["x": 3]).result(), 65)
    XCTAssertEqual(Expression("a^2 + b^2", variables: ["a": 4, "b": 3]).result(), 25)
    XCTAssertEqual(Expression("\(M_E)^(ln(5))").result()!, 5, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("sin(2π / 3) + cos(π / 3)").result()!, 0.86602540378 + 0.5, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("tan(3π / 4) - 1").result()!, -2, accuracy: targetAccuracy)
    
    XCTAssertEqual(Expression("1/3 + 1/6").result(), 0.5)
    XCTAssertEqual(Expression("sqrt(2) * sqrt(2)").result()!, 2, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("1 / (1 / (1 / x))", variables: ["x": 5]).result(), 0.2)
    XCTAssertEqual(Expression("cbrt(64)").result()!, 4, accuracy: targetAccuracy)
    
    XCTAssertEqual(Expression("arcsin(1)").result(), Double.pi / 2)
    XCTAssertEqual(Expression("arccos(1)").result(), 0)
    XCTAssertEqual(Expression("arctan(1)").result(), Double.pi / 4)
    XCTAssertEqual(Expression("2 * arctan(1)").result(), Double.pi / 2)
    XCTAssertEqual(Expression("sinh(0)").result(), 0)
    
    // Long and complex expressions involving multiple operations and functions
    XCTAssertEqual(Expression("cos(π/4) + sin(π/4) - tan(π/4) * sqrt(16) + abs(-5)").result()!, 2.41421356237, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("((12 + 18) * (34 / 2) + (89 * 3) - 123) / 5 + 456").result(), 586.8)
    XCTAssertEqual(Expression("((98765 + 4321 - 56789 / 3 + 210987 * 2) / 678 - 34567) * 890 + 12345 / 678").result(), -30100222.416420843)
    
    XCTAssertEqual(Expression("((12.5 + 18.75) * (34.2 / 2) - (56.3 / 7) + (89.1 * 3.2) - 123.45) / 5.5 + 456.78").result()!, 581.871298701, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("((987.6 - 654.3) / 3.2 + (210.2 * 2.1) - 345.7 + (678.8 / 9.4) * 8.2) * 12.3 / 7.4 - 89.5").result()!, 1226.9672229010928, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("(((123.12 + 345.34 - 567.56) * 234.23) / 567.67 + 789.78) * (12.21 - 456.45) + (789.89 / 123.32) - 90.01").result()!, -332770.36794005684, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("(12345.67 / 67.89 + 89.98 * 10.01 - 2345.65 + 67890.12 / (123.45 - 90.56) + 4567.89 - 890.12) * 12.34 / 345.67").result()!, 159.888617234, accuracy: targetAccuracy)
    XCTAssertEqual(Expression("((98765.43 + 4321.12 - 56789.32 / 3.45 + 210987.65 * 2.12) / 678.78 - 34567.89) * 890.01 + 12345.67 / 678.89").result()!, -30065679.072848197, accuracy: targetAccuracy)
  }
}
