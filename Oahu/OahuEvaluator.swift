import Foundation

public class OahuEvaluator: NSObject, Evaluator {
    public var closure: (urlIntercepted: String) -> Void
    public var url: String
    public var isAbsoluteUrl: Bool

    public required init(url: String, isAbsoluteUrl: Bool, closure: (urlIntercepted: String) -> Void) {
        self.closure = closure
        self.url = url
        self.isAbsoluteUrl = isAbsoluteUrl
    }
}
