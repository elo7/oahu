import Foundation
import WebKit

class CookieHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        let stringCookies = (message.body as AnyObject).components(separatedBy: "; ")

        for stringCookie in stringCookies where stringCookie.components(separatedBy: "=").count >= 2 {
            let cookieComponents = stringCookie.components(separatedBy: "=")

            if let cookies = HTTPCookieStorage.shared.cookies {
                for storedCookie in cookies where storedCookie.name == cookieComponents[0] {
                    HTTPCookieStorage.shared.deleteCookie(storedCookie)
                }
            }

            guard let host = message.webView?.url?.host else { return }

            if let newCookie = HTTPCookie(properties:[
                HTTPCookiePropertyKey.domain: host,
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: cookieComponents[0],
                HTTPCookiePropertyKey.value: cookieComponents[1],
                HTTPCookiePropertyKey.version: "0",
                HTTPCookiePropertyKey.expires: String(describing: Date().addingTimeInterval(60*60*24*365))
                ]) { HTTPCookieStorage.shared.setCookie(newCookie) }
        }
    }
}
