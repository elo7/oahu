import Foundation

public class OahuEvaluator: NSObject, Evaluator {
    public var closure: () -> Void
    public var url: String

    public required init(url: String, closure: () -> Void) {
        self.closure = closure
        self.url = url
    }
}
