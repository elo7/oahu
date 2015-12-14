import Foundation

public class OahuEvaluator: NSObject, Evaluator {
    public var closure: () -> Void
    public var url: String

    public required init(closure: () -> Void, url: String) {
        self.closure = closure
        self.url = url
    }
}