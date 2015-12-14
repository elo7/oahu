import Foundation
import WebKit

public class Oahu: NSObject, WKNavigationDelegate {
    private var wkWebView: WKWebView!
    private var interceptor: Interceptor?

    public init(forView view: UIView, allowsBackForwardNavigationGestures: Bool, interceptor: Interceptor?) {
        let webViewConfiguration = Configuration()

        wkWebView = WKWebView(frame: view.frame, configuration: webViewConfiguration.config)
        webViewConfiguration.scriptMessageHandler = ScriptHandler(wkWebView: wkWebView)
        self.interceptor = interceptor

        wkWebView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        view.addSubview(wkWebView)

        super.init()
        wkWebView.navigationDelegate = self
    }

    public func loadRequest(url: String) {
        guard let url = NSURL(string: url) else {
            return
        }

        let request = NSMutableURLRequest(URL: url)
        cookiesIfNeeded(forRequest: request)

        wkWebView.loadRequest(request)
    }

    func cookiesIfNeeded(forRequest request: NSMutableURLRequest) {
        guard let requestURL = request.URL,
            let validDomain = requestURL.host,
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies else { return }

        let header = cookies
            .filter {!$0.name.containsString("'") && $0.domain.hasSuffix(validDomain)}
            .map {"\($0.name)=\($0.value)"}
            .joinWithSeparator(";")

        if header != "" {
            request.setValue(header, forHTTPHeaderField: "Cookie")
        }
    }

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print("url:\(navigationAction.request.URL?.absoluteString)")

        if let interceptor = self.interceptor, let url = navigationAction.request.URL?.absoluteString {
            if interceptor.executeFirst(url) {
                decisionHandler(.Cancel)
                return
            }
        }

        decisionHandler(.Allow)
    }

    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("acabou o request")
    }
}
