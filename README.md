# SwiftExpression

A simple Swift package to safely evaluate mathematical expressions represented as strings. It leverages `NSExpression` for the evaluation and provides an additional layer of safety by catching any Objective-C exceptions that might occur during the evaluation process, preventing crashes.

## Usage
```swift
let expression = Expression("10 + 2")
let result = expression.result()
```
