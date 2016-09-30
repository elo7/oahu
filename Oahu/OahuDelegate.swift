import WebKit

@objc public protocol OahuDelegate {
    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didCommitNavigation navigation: WKNavigation!)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didFinishNavigation navigation: WKNavigation!)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: Error)

    @objc @available(iOS 8.0, *)
    optional func webView(_ webView: WKWebView, didReceiveAuthenticationChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)

    @objc @available(iOS 9.0, *)
    optional func webViewWebContentProcessDidTerminate(_ webView: WKWebView)
}
