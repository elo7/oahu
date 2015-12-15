import WebKit

extension Oahu: WKNavigationDelegate {

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        if let interceptor = self.interceptor, let url = navigationAction.request.URL?.absoluteString {
            if interceptor.executeFirst(url) {
                decisionHandler(.Cancel)
                return
            }
        }

        guard let _ = oahuDelegate?.webView?(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler) else {
            decisionHandler(.Allow)
            return
        }

        oahuDelegate?.webView?(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler)
    }

    public func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        guard let _ = oahuDelegate?.webView?(webView, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler) else {
            decisionHandler(.Allow)
            return
        }

        oahuDelegate?.webView?(webView, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler)
    }

    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }

    public func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }

    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        oahuDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }

    public func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didCommitNavigation: navigation)
    }

    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didFinishNavigation: navigation)
    }

    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        oahuDelegate?.webView?(webView, didFailNavigation: navigation, withError: error)
    }

    public func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        guard let _ = oahuDelegate?.webView?(webView, didReceiveAuthenticationChallenge: challenge, completionHandler: completionHandler) else {
            completionHandler(.PerformDefaultHandling, nil)
            return
        }

        oahuDelegate?.webView?(webView, didReceiveAuthenticationChallenge: challenge, completionHandler: completionHandler)
    }

    public func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        oahuDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
}
