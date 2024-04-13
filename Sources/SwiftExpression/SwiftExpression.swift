import Foundation
import SwiftExpressionObjC

/** A class for parsing and evaluating mathematical expressions, with built in support for sanitizing input and replacing constants/variables. */
public class Expression: Identifiable, Equatable {
  public let id = UUID()
  public let expressionString: String
  
  public init(_ expressionString: String) {
    self.expressionString = expressionString.addingMultiplicationSigns().replacingIntegersWithDecimals().replacingConstants()
  }
  
  //MARK: - Functions
  public func result(variables: [String:Any]=[:]) -> Double? {
    var value: Double?
    do {
      try SafeExpressionWrapper.perform {
        let expr = NSExpression(format: expressionString.replacingFunctions(variables).replacingVariables(variables))
        value = expr.expressionValue(with: nil, context: nil) as? Double
      }
    } catch {
      // Error
    }
    return value
  }
  
  public func isValid() -> Bool {
    return result(variables: ["x":1,"y":1]) != nil
  }
  
  public static func == (lhs: Expression, rhs: Expression) -> Bool {
    return lhs.result() == rhs.result()
  }
}
