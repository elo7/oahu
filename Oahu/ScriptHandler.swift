import Foundation
import WebKit

class ScriptHandler: NSObject, WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {

        switch message.name {
        case "updateCookies":
            print("xablau")
        default:
            print("bla")
        }

        let stringCookies = message.body.componentsSeparatedByString("; ")

        for stringCookie in stringCookies where stringCookie.componentsSeparatedByString("=").count >= 2 {
            let cookieComponents = stringCookie.componentsSeparatedByString("=")

            if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                for storedCookie in cookies where storedCookie.name == cookieComponents[0] {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(storedCookie)
                }
            }

            guard let host = message.webView?.URL?.host else { return }

            if let newCookie = NSHTTPCookie(properties:[
                NSHTTPCookieDomain: host,
                NSHTTPCookiePath: "/",
                NSHTTPCookieName: cookieComponents[0],
                NSHTTPCookieValue: cookieComponents[1],
                NSHTTPCookieVersion: "0",
                NSHTTPCookieExpires: String(NSDate().dateByAddingTimeInterval(60*60*24*365))
                ]) { NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie) }
        }
    }
}
