import Foundation
import SwiftExpressionObjC

public class Expression: Equatable {
  //MARK: - Variables
  private let string: String
  private let variables: [String:Any]
  
  //MARK: - Init
  init(_ string: String, variables: [String:Any]=[:]) {
    self.string = string
    self.variables = variables
  }
  
  //MARK: - Functions
  func result() -> Double? {
    var value: Double?
    do {
      try SafeExpressionWrapper.perform {
        let expr = NSExpression(format: self.string)
        value = expr.expressionValue(with: variables, context: nil) as? Double
      }
    } catch {
      print(error.localizedDescription)
    }
    return value
  }
  
  public static func == (lhs: Expression, rhs: Expression) -> Bool {
    return lhs.result() == rhs.result()
  }
}
