import Foundation

public protocol Evaluator {
    var closure: () -> Void {get}
    var url: String {get}
    init(closure: () -> Void, url: String)
}

extension Evaluator {
    func matchUrl(url: String) -> Bool {
        return url.containsString(self.url)
    }

    func execute() {
        closure()
    }
}

public class Interceptor: NSObject {
    private var evaluators: [Evaluator]!

    public init(evaluators: [Evaluator]) {
        self.evaluators = evaluators
    }

    public func add(evaluator evaluator: Evaluator) {
        self.evaluators.append(evaluator)
    }

    public func removeEvaluatorForUrl(url url: String) {
        self.evaluators = self.evaluators.filter{!url.containsString($0.url)}
    }

    func getEvaluators() -> [Evaluator] {
        return self.evaluators
    }

    public func executeFirst(url: String) -> Bool {
        if let first = self.evaluators.filter({$0.matchUrl(url)}).first {
            first.execute()
            return true
        }

        return false
    }
}
