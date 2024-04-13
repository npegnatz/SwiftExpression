import Foundation

/** String extensions to parse and prepare strings for NSExpression evaluation. Used in combination to produce a sanitzed input. */
extension String {
  static let pi: String = "π"
  
  //* Replaces key matches in the string with associated dictionary value
  func replacingVariables(_ variables: [String:Any]) -> String {
    return variables.reduce(self) { partialResult, variable in
      partialResult.replacingOccurrences(of: variable.key, with: "\(variable.value)")
    }
  }
  
  //* Replaces mathematical constant values in the string
  func replacingConstants() -> String {
    let constants = ["^":"**", "π":"\(Double.pi)"]
    return replacingVariables(constants)
  }
  
  //* Adds "*" multiplication signs to handle common string inputs (5x, 2(3), 5π)
  func addingMultiplicationSigns() -> String {
    let regexPattern = """
            (\\d)(?=[a-zA-Zπ(])|\
            ([a-zA-Zπ])(?<!\\b(abs|cos|sin|tan|sqrt|log|exp|min|max|ln|arcsin|arccos|arctan|cbrt|sinh))\
            (?=\\d|\\()|\
            (\\))(?=\\d|[a-zA-Zπ(])|\
            (\\))(?=\\()
            """
    let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
    let range = NSRange(self.startIndex..., in: self)
    
    let modifiedString = NSMutableString(string: self)
    let matches = regex.matches(in: self, options: [], range: range).reversed()  // Process from end to start to avoid index shift
    
    for match in matches {
      // Append '*' at the correct position after each match
      let position = match.range.location + match.range.length
      modifiedString.insert("*", at: position)
    }
    
    return String(modifiedString)
  }
  
  //* Replaces integers with decimal equivalents in a string
  func replacingIntegersWithDecimals() -> String {
    let regex = try! NSRegularExpression(pattern: "(?<!\\d\\.)(\\b\\d+\\b)(?!\\.\\d)")
    let newString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self), withTemplate: "$1.0")
    return newString
  }
  
  //* Recursively solves and replaces common trig functions with their values (NSExpression does not support trig functions)
  func replacingFunctions(_ variables: [String:Any] = [:]) -> String {
    var customExpression = self
    let functions = ["arccos", "arcsin", "arctan", "sinh", "cos", "sin", "tan", "cbrt"]
    
    for function in functions {
      let pattern = "\(function)\\(([^)]+)\\)"
      let regex = try! NSRegularExpression(pattern: pattern)
      let range = NSRange(location: 0, length: customExpression.utf16.count)
      
      var matches = [NSTextCheckingResult]()
      regex.enumerateMatches(in: customExpression, options: [], range: range) { match, _, _ in
        if let match = match {
          matches.append(match)
        }
      }
      
      for match in matches.reversed() {
        let argumentRange = match.range(at: 1)
        if argumentRange.location != NSNotFound,
           let range = Range(argumentRange, in: customExpression) {
          let argumentSubstring = String(customExpression[range])
          
          guard let argument = Expression(argumentSubstring).result(variables: variables) else { continue }
          
          let result: Double
          switch function {
          case "cos":
            result = cos(argument)
          case "sin":
            result = sin(argument)
          case "tan":
            result = tan(argument)
          case "arcsin":
            result = asin(argument)
          case "arccos":
            result = acos(argument)
          case "arctan":
            result = atan(argument)
          case "cbrt":
            result = pow(argument, 1.0/3.0)
          case "sinh":
            result = sinh(argument)
          default:
            continue
          }
          
          if let fullMatchRange = Range(match.range(at: 0), in: customExpression) {
            customExpression.replaceSubrange(fullMatchRange, with: "\(result)")
          }
        }
      }
    }
    return customExpression
  }
}
