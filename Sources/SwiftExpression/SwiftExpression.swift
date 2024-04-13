import Foundation
import SwiftExpressionObjC

/** A class for parsing and evaluating mathematical expressions, with built in support for sanitizing input and replacing constants/variables. */
public class Expression: Identifiable, Equatable {
  public let id = UUID()
  public let expressionString: String
  public let variables: [String:Any]
  
  public init(_ expressionString: String, variables: [String:Any]=[:]) {
    self.expressionString = expressionString.addingMultiplicationSigns().replacingIntegersWithDecimals().replacingConstants().replacingVariables(variables)
    self.variables = variables
  }
  
  //MARK: - Functions
  public func result() -> Double? {
    var value: Double?
    do {
      try SafeExpressionWrapper.perform {
        let expr = NSExpression(format: replacingTrigFunctions(expressionString))
        value = expr.expressionValue(with: variables, context: nil) as? Double
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
  
  func replacingTrigFunctions(_ str: String) -> String {
    var customExpression = str
    let trigFunctions = ["cos", "sin", "tan"]
    
    for trigFunction in trigFunctions {
      if customExpression.contains(trigFunction) {
        let range = NSRange(location: 0, length: customExpression.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\(trigFunction)\\(([^)]+)\\)")
        let matches = regex.matches(in: customExpression, options: [], range: range)
        
        for match in matches.reversed() {
          let argumentRange = match.range(at: 1)
          let start = customExpression.index(customExpression.startIndex, offsetBy: argumentRange.location)
          let end = customExpression.index(start, offsetBy: argumentRange.length)
          let argumentSubstring = customExpression[start..<end]
          
          guard let argument = Expression(String(argumentSubstring), variables: variables).result() else { continue }
          
          let result: Double
          switch trigFunction {
          case "cos":
            result = cos(argument)
          case "sin":
            result = sin(argument)
          case "tan":
            result = tan(argument)
          default:
            continue
          }
          
          let fullMatchRange = match.range(at: 0)
          let fullMatchStart = customExpression.index(customExpression.startIndex, offsetBy: fullMatchRange.location)
          let fullMatchEnd = customExpression.index(fullMatchStart, offsetBy: fullMatchRange.length)
          customExpression.replaceSubrange(fullMatchStart..<fullMatchEnd, with: "\(result)")
        }
      }
    }
    return customExpression
  }
  
  public static func == (lhs: Expression, rhs: Expression) -> Bool {
    return lhs.result() == rhs.result()
  }
}
