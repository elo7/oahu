import Foundation
import WebKit

@available(iOS 11.0, *)
class CookieStoreChangeObserver: NSObject, WKHTTPCookieStoreObserver {
	
	func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
		// TODO
	}
	
}
