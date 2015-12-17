import Foundation
import WebKit

protocol MessageHandler {

    var name: String {get set }
    func action()
}

class Xablau: NSObject, MessageHandler {
    var name: String

    init(name: String) {
        self.name = name
    }

    func action() {
        //
    }
}

