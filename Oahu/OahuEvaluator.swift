import Foundation

open class OahuEvaluator: NSObject, Evaluator {

    open var closure: (_ urlIntercepted: String) -> Void
    open var url: String
    open var isAbsoluteUrl: Bool

    public required init(url: String, isAbsoluteUrl: Bool, closure: @escaping (String) -> Void) {
        self.closure = closure
        self.url = url
        self.isAbsoluteUrl = isAbsoluteUrl
    }

    public convenience init(url: String, closure: @escaping (_ urlIntercepted: String) -> Void) {
        self.init(url: url, isAbsoluteUrl: false, closure: closure)
    }
}
