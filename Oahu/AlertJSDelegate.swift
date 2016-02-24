import UIKit
import WebKit

class AlertJSDelegate: NSObject, WKUIDelegate {
    let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        AlertJS().presentAlertOnController(self.rootViewController, title: "Alert", message: message, handler: completionHandler)
    }

    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        AlertJS().presentConfirmOnController(self.rootViewController, title: "Confirm", message: message, handler: completionHandler)
    }

    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        AlertJS().presentPromptOnController(self.rootViewController, title: "Prompt", message: prompt, defaultText: defaultText, completionHandler: completionHandler)
    }
}

struct AlertJS {
    func presentAlertOnController(parentController: UIViewController, title: String, message: String, handler: () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            handler()
        }))

        parentController.presentViewController(alert, animated: true, completion: nil)
    }

    func presentConfirmOnController(parentController: UIViewController, title: String, message: String, handler: (Bool) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            handler(true)
        }))

        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            handler(false)
        }))

        parentController.presentViewController(alert, animated: true, completion: nil)
    }

    func presentPromptOnController(parentController: UIViewController, title: String, message: String, defaultText: String?, completionHandler: (String?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textFilter) -> Void in
            textFilter.text = defaultText
        }

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let textFields = alert.textFields {
                completionHandler(textFields[0].text)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            completionHandler(nil)
        }))

        parentController.presentViewController(alert, animated: true, completion: nil)
    }
}
