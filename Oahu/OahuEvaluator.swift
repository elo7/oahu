import Foundation

open class OahuEvaluator: NSObject, Evaluator {

    open var closure: (_ urlIntercepted: String) -> Void
    open var url: String
    open var isAbsoluteUrl: Bool
    open var stopLoadingURL: (_ urlIntercepted: String) -> Bool
    
    public required init(url: String, isAbsoluteUrl: Bool, closure: @escaping (String) -> Void) {
        self.closure = closure
        self.url = url
        self.isAbsoluteUrl = isAbsoluteUrl
        self.stopLoadingURL = { (urlIntercepted) in
            return true
        }
    }

    public convenience init(url: String, closure: @escaping (_ urlIntercepted: String) -> Void) {
        self.init(url: url, isAbsoluteUrl: false, closure: closure)
    }
    
    public convenience init(url: String, closure: @escaping (_ urlIntercepted: String) -> Void, stopLoadingURL: @escaping (_ urlIntercepted: String) -> Bool) {
        self.init(url: url, isAbsoluteUrl: false, closure: closure)
        self.stopLoadingURL = stopLoadingURL
    }
}
