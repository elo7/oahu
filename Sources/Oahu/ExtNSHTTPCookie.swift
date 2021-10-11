import Foundation

extension HTTPCookie {
    var javascriptString: String {
        var string = "\(name)=\(value); domain=\(domain);path=\(path)"

        if isSecure {
            string.append(";secure=true")
        }

        return string;
    }
}
