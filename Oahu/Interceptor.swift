import Foundation

@objc public protocol Evaluator {
    var closure: (_ urlIntercepted: String) -> Void {get}
    var url: String {get}
    var isAbsoluteUrl: Bool {get}
    init(url: String, isAbsoluteUrl: Bool, closure: @escaping (_ urlIntercepted: String) -> Void)
}

extension Evaluator {
    func matchUrl(_ url: String) -> Bool {
        if self.isAbsoluteUrl {
            return url == self.url
        }
        
        return url.contains(self.url)
    }
    
    func execute(_ urlIntercepted: String) {
        closure(urlIntercepted)
    }
}

open class Interceptor: NSObject {
    fileprivate var evaluators: [OahuEvaluator]!

    public init(evaluators: [OahuEvaluator]) {
        self.evaluators = evaluators
    }

    open func add(evaluator: OahuEvaluator) {
        self.evaluators.append(evaluator)
    }

    open func removeEvaluatorForUrl(url: String) {
        self.evaluators = self.evaluators.filter{!url.contains($0.url)}
    }

    func getEvaluators() -> [OahuEvaluator] {
        return self.evaluators
    }

    open func executeFirst(_ url: String) -> Bool {
        if let first = self.evaluators.filter({ (oahuEvaluator) -> Bool in
            return oahuEvaluator.matchUrl(url) && oahuEvaluator.stopLoadingURL(url)
        }).first {
            first.execute(url)
            return true
        }

        return false
    }
}
