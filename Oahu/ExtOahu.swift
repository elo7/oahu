import WebKit

extension Oahu: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let interceptor = self.interceptor, let url = navigationAction.request.url?.absoluteString {
            if interceptor.executeFirst(url) {
                decisionHandler(.cancel)
                return
            }
        }

        guard let _ = oahuDelegate?.webView?(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler) else {
            decisionHandler(.allow)
            return
        }

        oahuDelegate?.webView?(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let _ = oahuDelegate?.webView?(webView, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler) else {
            decisionHandler(.allow)
            return
        }

        oahuDelegate?.webView?(webView, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: decisionHandler)
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }

    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        oahuDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didCommitNavigation: navigation)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        oahuDelegate?.webView?(webView, didFinishNavigation: navigation)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        oahuDelegate?.webView?(webView, didFailNavigation: navigation, withError: error)
    }

    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let _ = oahuDelegate?.webView?(webView, didReceiveAuthenticationChallenge: challenge, completionHandler: completionHandler) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        oahuDelegate?.webView?(webView, didReceiveAuthenticationChallenge: challenge, completionHandler: completionHandler)
    }

    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        oahuDelegate?.webViewWebContentProcessDidTerminate?(webView)
    }
}
