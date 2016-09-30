import Foundation
import WebKit

open class ScriptMessageHandler {
    fileprivate(set) var name: String
    fileprivate(set) var handler: ((String?) -> ())

    public init(forEventName name: String, handler: @escaping (String?) -> ()) {
        self.name = name
        self.handler = handler
    }
}
