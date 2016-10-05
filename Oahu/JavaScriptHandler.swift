import Foundation
import WebKit

class JavaScriptHandler: NSObject, WKScriptMessageHandler  {

    var messageHandlers: [ScriptMessageHandler]

    init(messageHandlers: [ScriptMessageHandler]) {
        self.messageHandlers = messageHandlers
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let messageHandler = messageHandlers.filter({$0.name == message.name}).first else {
            return
        }

        if let param = message.body as? String , param != "" {
            messageHandler.handler(param)
        } else {
            messageHandler.handler(nil)
        }
    }
}
