import Foundation
import WebKit

@objc open class Oahu: NSObject {
    fileprivate var wkWebView: WKWebView!
    fileprivate(set) var interceptor: Interceptor?
    open weak var oahuDelegate: OahuDelegate?
    fileprivate let webViewConfiguration = Configuration()
    fileprivate var delegate: AlertJSDelegate?
    fileprivate let refreshControl: UIRefreshControl

    open var javaScriptHandlers:[ScriptMessageHandler]? {
        didSet {
            webViewConfiguration.messageHandlers = javaScriptHandlers
        }
    }

    open var allowsBackForwardNavigationGestures: Bool {
        get {
            return self.wkWebView.allowsBackForwardNavigationGestures
        }
        set (newValue) {
            self.wkWebView.allowsBackForwardNavigationGestures = newValue
        }
    }

    open var backForwardList: WKBackForwardList {
        get {
            return self.wkWebView.backForwardList
        }
    }
    
    open var getWKWebView: WKWebView {
        get {
            return self.wkWebView
        }
    }

    open var allowsLinkPreview: Bool {
        get {
            return self.wkWebView.allowsLinkPreview
        }
        set (newValue) {
            self.wkWebView.allowsLinkPreview = newValue
        }
    }

    public init(forView view: UIView, allowsBackForwardNavigationGestures: Bool, interceptor: Interceptor? = nil, viewController: UIViewController? = nil) {
		
		
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), configuration: webViewConfiguration.config)

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
            wkWebView.uiDelegate = self.delegate
        }
    }

    open var enableZoom: Bool {
        didSet {
            if enableZoom {
                wkWebView.scrollView.delegate = nil
            } else {
                wkWebView.scrollView.delegate = self
            }
        }
    }

    open func enablePullToRefresh() {
        self.refreshControl.addTarget(self, action: #selector(Oahu.refresh), for: UIControl.Event.valueChanged)
        self.wkWebView.scrollView.addSubview(self.refreshControl)
    }

    @objc open func refresh() {
        self.wkWebView.reload()
        self.refreshControl.endRefreshing()
    }

    open func loadRequest(_ url: String, httpMethod: HTTPMethod? = HTTPMethod.GET) {
        guard let url = URL(string: url) else {
            return
        }

        let request = NSMutableURLRequest(url: url)
        if let httpMethod = httpMethod {
            request.httpMethod = httpMethod.rawValue
        }

        wkWebView.load(request as URLRequest)
    }

    open func loadHTMLString(_ htmlString: String) {
        wkWebView.loadHTMLString(htmlString, baseURL: nil)
    }

    open func getWebView() -> WKWebView {
        return self.wkWebView
    }
}

extension UIView {

    func addAllConstraints(_ contentView:UIView){
        let topConstraint = constraint(contentView, attribute:NSLayoutConstraint.Attribute.top)
        let bottomConstraint = constraint(contentView, attribute:NSLayoutConstraint.Attribute.bottom)
        let leadingConstraint = constraint(contentView, attribute:NSLayoutConstraint.Attribute.leading)
        let trailingConstraint = constraint(contentView, attribute:NSLayoutConstraint.Attribute.trailing)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }

    fileprivate func constraint(_ contentView:UIView, attribute:NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item:self, attribute:attribute, relatedBy:NSLayoutConstraint.Relation.equal, toItem:contentView, attribute:attribute , multiplier:1.0, constant:0)
    }
    
}

extension Oahu: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }

}

// Mark: - WKWebView methods
extension Oahu {

    public func canGoBack() -> Bool {
        return self.wkWebView.canGoBack
    }

    public func canGoForward() -> Bool {
        return self.wkWebView.canGoForward
    }

    public func goBack() {
        self.wkWebView.goBack()
    }

    public func goForward() {
        self.wkWebView.goForward()
    }

    public func goToBackForwardListItem(_ item: WKBackForwardListItem) -> WKNavigation? {
        return self.wkWebView.go(to: item)
    }
}
