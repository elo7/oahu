import Foundation
import WebKit

public class Oahu: NSObject {
    private var wkWebView: WKWebView!
    private(set) var interceptor: Interceptor?
    public weak var oahuDelegate: OahuDelegate?
    private let webViewConfiguration = Configuration()
    private var delegate: AlertJSDelegate?
    private let refreshControl: UIRefreshControl

    public var javaScriptHandlers:[ScriptMessageHandler]? {
        didSet {
            webViewConfiguration.messageHandlers = javaScriptHandlers
        }
    }

    public init(forView view: UIView, allowsBackForwardNavigationGestures: Bool, interceptor: Interceptor? = nil, viewController: UIViewController? = nil) {
        wkWebView = WKWebView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), configuration: webViewConfiguration.config)

        self.interceptor = interceptor

        wkWebView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        view.addSubview(wkWebView)
        view.addAllConstraints(wkWebView)
        self.refreshControl = UIRefreshControl()
        self.enableZoom = true
        super.init()
        wkWebView.navigationDelegate = self
        if let viewController = viewController {
            self.delegate = AlertJSDelegate(rootViewController: viewController)
            wkWebView.UIDelegate = self.delegate
        }
    }

    public var enableZoom: Bool {
        didSet {
            if !enableZoom {
                wkWebView.scrollView.delegate = self
            } else {
                wkWebView.scrollView.delegate = nil
            }
        }
    }

    public func enablePullToRefresh() {
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.wkWebView.scrollView.addSubview(self.refreshControl)
    }

    public func refresh() {
        self.wkWebView.reload()
        self.refreshControl.endRefreshing()
    }

    public func loadRequest(url: String) {
        guard let url = NSURL(string: url) else {
            return
        }

        let request = NSMutableURLRequest(URL: url)
        cookiesIfNeeded(forRequest: request)

        wkWebView.loadRequest(request)
    }

    public func loadHTMLString(htmlString: String) {
        wkWebView.loadHTMLString(htmlString, baseURL: nil)
    }

    func cookiesIfNeeded(forRequest request: NSMutableURLRequest) {

        guard let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies else { return }

        let header = cookies
            .filter {!$0.name.containsString("'")}
            .map {"\($0.name)=\($0.value)"}
            .joinWithSeparator(";")

        if header != "" {
            request.setValue(header, forHTTPHeaderField: "Cookie")
        }
    }
}

extension UIView {

    func addAllConstraints(contentView:UIView){
        let topConstraint = constraint(contentView, attribute:NSLayoutAttribute.Top)
        let bottomConstraint = constraint(contentView, attribute:NSLayoutAttribute.Bottom)
        let leadingConstraint = constraint(contentView, attribute:NSLayoutAttribute.Leading)
        let trailingConstraint = constraint(contentView, attribute:NSLayoutAttribute.Trailing)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }

    private func constraint(contentView:UIView, attribute:NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item:self, attribute:attribute, relatedBy:NSLayoutRelation.Equal, toItem:contentView, attribute:attribute , multiplier:1.0, constant:0)
    }
    
}

extension Oahu: UIScrollViewDelegate {

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nil
    }

}
