import Foundation

#if _runtime(_ObjC)

internal struct ObjCMatcherWrapper : Matcher {
    let matcher: NMBMatcher

    func matches(_ actualExpression: Expression<NSObject>, failureMessage: FailureMessage) -> Bool {
        return matcher.matches(
            ({ try! actualExpression.evaluate() }),
            failureMessage: failureMessage,
            location: actualExpression.location)
    }

    func doesNotMatch(_ actualExpression: Expression<NSObject>, failureMessage: FailureMessage) -> Bool {
        return matcher.doesNotMatch(
            ({ try! actualExpression.evaluate() }),
            failureMessage: failureMessage,
            location: actualExpression.location)
    }
}

// Equivalent to Expectation, but for Nimble's Objective-C interface
open class NMBExpectation : NSObject {
    internal let _actualBlock: () -> NSObject!
    internal var _negative: Bool
    internal let _file: FileString
    internal let _line: UInt
    internal var _timeout: TimeInterval = 1.0

    public init(actualBlock: @escaping () -> NSObject!, negative: Bool, file: FileString, line: UInt) {
        self._actualBlock = actualBlock
        self._negative = negative
        self._file = file
        self._line = line
    }

    fileprivate var expectValue: Expectation<NSObject> {
        return expect(expression: _file as NSObject?, file: _line){
            self._actualBlock() as NSObject?
        }
    }

    open var withTimeout: (TimeInterval) -> NMBExpectation {
        return ({ timeout in self._timeout = timeout
            return self
        })
    }

    open var to: (NMBMatcher) -> Void {
        return ({ matcher in
            self.expectValue.to(ObjCMatcherWrapper(matcher: matcher))
        })
    }

    open var toWithDescription: (NMBMatcher, String) -> Void {
        return ({ matcher, description in
            self.expectValue.to(ObjCMatcherWrapper(matcher: matcher), description: description)
        })
    }

    open var toNot: (NMBMatcher) -> Void {
        return ({ matcher in
            self.expectValue.toNot(
                ObjCMatcherWrapper(matcher: matcher)
            )
        })
    }

    open var toNotWithDescription: (NMBMatcher, String) -> Void {
        return ({ matcher, description in
            self.expectValue.toNot(
                ObjCMatcherWrapper(matcher: matcher), description: description
            )
        })
    }

    open var notTo: (NMBMatcher) -> Void { return toNot }

    open var notToWithDescription: (NMBMatcher, String) -> Void { return toNotWithDescription }

    open var toEventually: (NMBMatcher) -> Void {
        return ({ matcher in
            self.expectValue.toEventually(
                ObjCMatcherWrapper(matcher: matcher),
                timeout: self._timeout,
                description: nil
            )
        })
    }

    open var toEventuallyWithDescription: (NMBMatcher, String) -> Void {
        return ({ matcher, description in
            self.expectValue.toEventually(
                ObjCMatcherWrapper(matcher: matcher),
                timeout: self._timeout,
                description: description
            )
        })
    }

    open var toEventuallyNot: (NMBMatcher) -> Void {
        return ({ matcher in
            self.expectValue.toEventuallyNot(
                ObjCMatcherWrapper(matcher: matcher),
                timeout: self._timeout,
                description: nil
            )
        })
    }

    open var toEventuallyNotWithDescription: (NMBMatcher, String) -> Void {
        return ({ matcher, description in
            self.expectValue.toEventuallyNot(
                ObjCMatcherWrapper(matcher: matcher),
                timeout: self._timeout,
                description: description
            )
        })
    }

    open var toNotEventually: (NMBMatcher) -> Void { return toEventuallyNot }

    open var toNotEventuallyWithDescription: (NMBMatcher, String) -> Void { return toEventuallyNotWithDescription }

    open class func failWithMessage(_ message: String, file: FileString, line: UInt) {
        fail(message, location: SourceLocation(file: file, line: line))
    }
}

#endif
