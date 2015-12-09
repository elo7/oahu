import Foundation
import WebKit

class ScriptHandler: NSObject, WKScriptMessageHandler {

    private weak var wkWebView: WKWebView?

    init(wkWebView:WKWebView) {
        self.wkWebView = wkWebView
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        guard let wkWebViewURL = wkWebView?.URL,
            let cookiesForURL = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(wkWebViewURL) else {return}

        for cookie in message.body.componentsSeparatedByString("; ") where cookie.componentsSeparatedByString("=").count >= 2 {
            let cookieComponents = cookie.componentsSeparatedByString("=")
            for cookieForURL in cookiesForURL where cookieForURL.name == cookie.componentsSeparatedByString("=")[0] {
                guard var properties = cookieForURL.properties, let cookieValue = cookieComponents[safe: 1] else { return }

                if cookieValue != cookieForURL.value {
                    properties[NSHTTPCookieValue] = cookieValue

                    guard let updatedCookie = NSHTTPCookie(properties: properties) else { return }
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(updatedCookie)
                }
            }
        }
    }
}
