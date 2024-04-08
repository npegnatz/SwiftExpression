import Foundation

extension NSExpression {
  
  static func customBuilder(_ string: String) -> NSExpression {
    var customExpression = string
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
          
          guard let argument = Double(argumentSubstring) else { continue }
          
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
    return NSExpression(format: customExpression)
  }
}
