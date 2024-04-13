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
            ([a-zA-Zπ])(?<!\\b(abs|cos|sin|tan|sqrt|log|exp|min|max|ln))\
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
  func replacingTrigFunctions(_ variables: [String:Any]=[:]) -> String {
    var customExpression = self
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
}
