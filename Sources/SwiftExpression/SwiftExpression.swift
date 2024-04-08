import Foundation
import SwiftExpressionObjC

class Expression {
  private let string: String
  
  init(_ string: String) {
    self.string = string
  }
  
  func result() -> Double? {
    var result: Double?
    do {
      try SafeExpressionWrapper.perform {
        let expr = NSExpression(format: self.string)
        result = expr.expressionValue(with: nil, context: nil) as? Double
      }
    } catch {
      result = nil
    }
    return result
  }
}
