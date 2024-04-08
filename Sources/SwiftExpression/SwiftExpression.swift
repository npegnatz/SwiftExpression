import Foundation
import SwiftExpressionObjC

public class Expression: Equatable {
  //MARK: - Variables
  public let string: String
  private let variables: [String:Any]
  public var error: Error?
  
  //MARK: - Init
  public init(_ string: String, variables: [String:Any]=[:]) {
    self.string = string
    self.variables = variables
  }
  
  //MARK: - Functions
  public func result() -> Double? {
    var value: Double?
    do {
      try SafeExpressionWrapper.perform {
        let withVariablesReplaced = variables.reduce(string) { partialResult, variable in
          partialResult.replacingOccurrences(of: variable.key, with: "\(variable.value)")
        }
        let expr = NSExpression.customBuilder(withVariablesReplaced)
        value = expr.expressionValue(with: variables, context: nil) as? Double
      }
    } catch {
      self.error = error
    }
    return value
  }
  
  public static func == (lhs: Expression, rhs: Expression) -> Bool {
    return lhs.result() == rhs.result()
  }
}
