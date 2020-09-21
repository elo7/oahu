import Foundation
import WebKit

class Configuration {
    fileprivate let webkitUserContentController = WKUserContentController()
    fileprivate let cookieHandler = CookieHandler()
    fileprivate let processPool = WKProcessPool()

    var messageHandlers: [ScriptMessageHandler]? {
        set(newValue) {
            if let messageHandlers = newValue {
                let javaScriptHandler = JavaScriptHandler(messageHandlers: messageHandlers)
                for messageHandler in messageHandlers {
                    webkitUserContentController.add(javaScriptHandler, name: messageHandler.name)
                }
            }
        }
        get {
            return self.messageHandlers
        }
    }

    lazy var cookieInScript: WKUserScript = {
        let cookies = HTTPCookieStorage.shared.cookies!
            .filter{!$0.name.contains("'")}
            .map{"if (cookieNames.indexOf('\($0.name)') == -1) { document.cookie='\($0.javascriptString)'; };\n"}
            .joined(separator: "")

        let script = "var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n" + cookies

        return WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }()

    lazy var cookieOutScript: WKUserScript = {
        return WKUserScript(source: "window.webkit.messageHandlers.updateCookies.postMessage(document.cookie);", injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }()

    var config: WKWebViewConfiguration {
        let webkitWebViewConfiguration = WKWebViewConfiguration()
		if #available(iOS 11.0, *) {
			let cookieStore = webkitWebViewConfiguration.websiteDataStore.httpCookieStore
			
			if let cookies = HTTPCookieStorage.shared.cookies {
				for cookie in cookies {
					cookieStore.setCookie(cookie, completionHandler: nil)
				}
			}
			
			cookieStore.add(CookieStoreChangeObserver())
			
		} else {
			webkitUserContentController.addUserScript(cookieInScript)
			webkitUserContentController.addUserScript(cookieOutScript)
			webkitUserContentController.add(cookieHandler, name: "updateCookies")
			
			webkitWebViewConfiguration.processPool = processPool
			webkitWebViewConfiguration.userContentController = webkitUserContentController
		}

        return webkitWebViewConfiguration
    }
}
