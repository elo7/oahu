import UIKit
import WebKit

class AlertJSDelegate: NSObject, WKUIDelegate {
    let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        AlertJS().presentAlertOnController(self.rootViewController, title: NSLocalizedString("Alert", comment: ""), message: message, handler: completionHandler)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        AlertJS().presentConfirmOnController(self.rootViewController, title: NSLocalizedString("Confirm", comment: ""), message: message, handler: completionHandler)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        AlertJS().presentPromptOnController(self.rootViewController, title: NSLocalizedString("Prompt", comment: ""), message: prompt, defaultText: defaultText, completionHandler: completionHandler)
    }
}

struct AlertJS {
    func presentAlertOnController(_ parentController: UIViewController, title: String, message: String, handler: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            handler()
        }))

        parentController.present(alert, animated: true, completion: nil)
    }

    func presentConfirmOnController(_ parentController: UIViewController, title: String, message: String, handler: @escaping (Bool) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (action) -> Void in
            handler(true)
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            handler(false)
        }))

        parentController.present(alert, animated: true, completion: nil)
    }

    func presentPromptOnController(_ parentController: UIViewController, title: String, message: String, defaultText: String?, completionHandler: @escaping (String?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
        alert.addTextField { (textFilter) -> Void in
            textFilter.text = defaultText
        }

        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (action) -> Void in
            if let textFields = alert.textFields {
                completionHandler(textFields[0].text)
            }
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            completionHandler(nil)
        }))

        parentController.present(alert, animated: true, completion: nil)
    }
}
