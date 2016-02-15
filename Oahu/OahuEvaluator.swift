import Foundation

public class OahuEvaluator: NSObject, Evaluator {
    public var closure: (urlIntercepted: String) -> Void
    public var url: String

    public required init(url: String, closure: (urlIntercepted: String) -> Void) {
        self.closure = closure
        self.url = url
    }
}
