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
    return self.replacingOccurrences(of: String.pi, with: Double.pi.description)
  }
  
  //* Adds "*" multiplication signs to handle common string inputs (5x, 2(3), 5π)
  func addingMultiplicationSigns() -> String {
    let regexPattern = """
            (\\d)(?=[a-zA-Zπ(])|\
            ([a-zA-Zπ])(?<!\\b(abs|cos|sin|tan|sqrt|log|exp|min|max))\
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
}
