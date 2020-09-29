# Oahu

*Swift lightweight wrapper for WKWebView to maintain persisted cookies through navigation, intercept requests and handle JavaScript messages*

## Requirements
- iOS 11.0+
- Xcode 9.0+

## Instalation
Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9).


### CocoaPods
```ruby
use_frameworks!

pod 'Oahu', :git => 'git@github.com:elo7/oahu.git'
```

### Carthage
```ruby
github "elo7/oahu" "master"
```

And add the path to the framework under “Input Files”, e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/oahu.framework
```

## Getting started
#### Initialization
```swift
import Oahu
let browser = Oahu(forView: view, allowsBackForwardNavigationGestures: true)
browser.loadRequest("http://www.elo7.com")
```

#### Delegate methods
OahuDelegate responds to all WKNavigationDelegate methods
```swift
class ViewController: UIViewController, OahuDelegate
```

And then

```swift
browser.oahuDelegate = self
```

#### Interceptor
With Oahu you can intercept requests and perform some action. It is generally used to show some native content giving a determined request.

First you need to create a Evaluator:
```swift
let evaluator = OahuEvaluator(url: "tech") {
	print("Tech request blocked")
}
```

The first parameter **url** is the term of the request that if appears, should stop the request.

The second parameter **closure** is the action that should be taken.

You should have an array of Evaluators and put all the Evaluators inside it.

```swift
var evalutors = [Evaluator]()
evalutors.append(evaluator)
```

Then you must create an Interceptor that uses all the evaluators inside the array.

```swift
let interceptor = Interceptor(evaluators: evalutors)
```

And finally, instantiate Oahu with a constructor that receives another argument.
```swift
browser = Oahu(forView: view, allowsBackForwardNavigationGestures: true, interceptor: interceptor)
```

#### JavaScript handling
Sometimes you need to talk with a JavaScript posted by your website and handle in a native way. To perform that task you should do this:

First you need to create a ScriptMessageHandler:
```swift
let messageHandler = ScriptMessageHandler(forEventName: "shippingCancel") { param in
	print("Perform some native task when JavaScript trigger this event")
}
```

The first parameter **forEventName** is the event your JavaScript is triggering using WKWebKit convention.

```swift
window.webkit.messageHandlers.{NAME}.postMessage()
```

The second parameter **handler** is the action that should be taken.

You should have an array of ScriptMessageHandlers and put yours ScriptMessageHandler inside it.

```swift
var scriptMessages = [ScriptMessageHandlers]()
scriptMessages.append(messageHandler)
```

Then, you just need to assign Oahu's javaScriptHandlers with your array.

```swift
browser?.javaScriptHandlers = scriptMessages
```

#### Load HTML String
To load HTML string content, you can use the same function of WKWebView
```swift
browser?.loadHTMLString("<html><body>Hi Oahu</body></html>")
```

## Contribute
- If you **found a bug**, open an issue.
- If you ***have a feature request***, open an issue.
- If you ***want to contribute***, submit a pull request


## License
Oahu is released under the MIT license. See LICENSE for details.
