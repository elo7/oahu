import Foundation
import WebKit

public struct Oahu {
    private var wkWebView: WKWebView!

    public weak var navigationDelegate: WKNavigationDelegate? {
        didSet {
            wkWebView.navigationDelegate = navigationDelegate
        }
    }

    public init(forView view: UIView, allowsBackForwardNavigationGestures: Bool) {
        let webViewConfiguration = Configuration()

        wkWebView = WKWebView(frame: view.frame, configuration: webViewConfiguration.config)
        webViewConfiguration.scriptMessageHandler = ScriptHandler(wkWebView: wkWebView)

        wkWebView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        view.addSubview(wkWebView)
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
}
