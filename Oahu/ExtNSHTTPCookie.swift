import Foundation

extension NSHTTPCookie {
    var javascriptString: String {
        var string = "\(name)=\(value); domain=\(domain);path=\(path)"

        if secure {
            string.appendContentsOf(";secure=true")
        }

        return string;
    }
}
