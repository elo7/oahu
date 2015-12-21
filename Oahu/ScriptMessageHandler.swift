import Foundation
import WebKit

public class ScriptMessageHandler {
    private(set) var name: String
    private(set) var handler: ((String?) -> ())

    public init(forEventName name: String, handler: (String?) -> ()) {
        self.name = name
        self.handler = handler
    }
}
