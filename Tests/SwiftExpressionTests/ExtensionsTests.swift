import XCTest
@testable import SwiftExpression

final class ExtensionsTests: XCTestCase {
  
  func testReplacingVariables() {
    XCTAssertEqual("5cat".replacingVariables(["cat":"π"]), "5π")
    XCTAssertEqual("sin(x)".replacingVariables(["x":12]), "sin(12)")
  }
  
  func testReplacingConstants() {
    XCTAssertEqual("π".replacingConstants(), "3.141592653589793")
    XCTAssertEqual("2π + π".replacingConstants(), "23.141592653589793 + 3.141592653589793")
    XCTAssertEqual("πππ".replacingConstants(), "3.1415926535897933.1415926535897933.141592653589793")
  }
  
  func testAddingMultiplicationSigns() {
    // Test adding multiplication signs
    XCTAssertEqual("2(3)".addingMultiplicationSigns(), "2*(3)")
    XCTAssertEqual("x(5)".addingMultiplicationSigns(), "x*(5)")
    XCTAssertEqual("7x(2+3)".addingMultiplicationSigns(), "7*x*(2+3)")
    XCTAssertEqual("3y5z".addingMultiplicationSigns(), "3*y*5*z")
    XCTAssertEqual("4(5)(6)7".addingMultiplicationSigns(), "4*(5)*(6)*7")
    XCTAssertEqual("2a(3+b)5".addingMultiplicationSigns(), "2*a*(3+b)*5")
    XCTAssertEqual("x5".addingMultiplicationSigns(), "x*5")
    XCTAssertEqual("3(4+5(6))".addingMultiplicationSigns(), "3*(4+5*(6))")
  }
  
  func testReplacingIntegersWithDecimals() {
    // Test replacing integers with decimals
    XCTAssertEqual("5".replacingIntegersWithDecimals(), "5.0")
    XCTAssertEqual("(5+3)*7".replacingIntegersWithDecimals(), "(5.0+3.0)*7.0")
    XCTAssertEqual("123".replacingIntegersWithDecimals(), "123.0")
    XCTAssertEqual("9 + 12".replacingIntegersWithDecimals(), "9.0 + 12.0")
  }
  
  func testReplacingTrigFunctions() {
    XCTAssertEqual("tan(0)".replacingTrigFunctions(), "0.0")
  }
}
