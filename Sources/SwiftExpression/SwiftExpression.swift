import Foundation
import SwiftExpressionObjC

/** A class for parsing and evaluating mathematical expressions, with built in support for sanitizing input and replacing constants/variables. */
public class Expression: Identifiable, Equatable {
  public let id = UUID()
  public let expressionString: String
  public let variables: [String:Any]
  
  public init(_ expressionString: String, variables: [String:Any]=[:]) {
    self.expressionString = expressionString.addingMultiplicationSigns().replacingIntegersWithDecimals().replacingConstants().replacingVariables(variables).replacingFunctions(variables)
    self.variables = variables
  }
  
  //MARK: - Functions
  public func result() -> Double? {
    var value: Double?
    do {
      try SafeExpressionWrapper.perform {
        let expr = NSExpression(format: expressionString)
        value = expr.expressionValue(with: nil, context: nil) as? Double
      }
    } catch {
      // Error
    }
    return value
  }
  
  public func isValid() -> Bool {
    var valid = false
    do {
      try SafeExpressionWrapper.perform {
        let _ = NSExpression(format: expressionString)
        valid = true
      }
    } catch {
      valid = false
    }
    return valid
  }
  
  public static func == (lhs: Expression, rhs: Expression) -> Bool {
    return lhs.result() == rhs.result()
  }
}
