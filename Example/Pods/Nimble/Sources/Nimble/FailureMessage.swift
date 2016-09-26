import Foundation

/// Encapsulates the failure message that matchers can report to the end user.
///
/// This is shared state between Nimble and matchers that mutate this value.
open class FailureMessage: NSObject {
    open var expected: String = "expected"
    open var actualValue: String? = "" // empty string -> use default; nil -> exclude
    open var to: String = "to"
    open var postfixMessage: String = "match"
    open var postfixActual: String = ""
    open var userDescription: String? = nil

    open var stringValue: String {
        get {
            if let value = _stringValueOverride {
                return value
            } else {
                return computeStringValue()
            }
        }
        set {
            _stringValueOverride = newValue
        }
    }

    internal var _stringValueOverride: String?

    public override init() {
    }

    public init(stringValue: String) {
        _stringValueOverride = stringValue
    }

    internal func stripNewlines(_ str: String) -> String {
        var lines: [String] = NSString(string: str).components(separatedBy: "\n") as [String]
        let whitespace = CharacterSet.whitespacesAndNewlines
        lines = lines.map { line in NSString(string: line).trimmingCharacters(in: whitespace) }
        return lines.joined(separator: "")
    }

    internal func computeStringValue() -> String {
        var value = "\(expected) \(to) \(postfixMessage)"
        if let actualValue = actualValue {
            value = "\(expected) \(to) \(postfixMessage), got \(actualValue)\(postfixActual)"
        }
        value = stripNewlines(value)
        
        if let userDescription = userDescription {
            return "\(userDescription)\n\(value)"
        }
        
        return value
    }
}
