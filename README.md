#Oahu

*Swift lightweight wrapper for WKWebView to maintain persisted cookies trough navigation*

## Requirements
- iOS 8+
- Xcode 7.1+

## Instalation
Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9).


### CocoaPods
```ruby
use_frameworks! 

pod 'oahu', :git => 'git@github.com:elo7/oahu.git'
```

### Carthage
```ruby
github "elo7/oahu" ~> 0.0.1
```

And add the path to the framework under “Input Files”, e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/oahu.framework
```

## Getting started
#### Initialization
```swift
import oahu
let browser = Oahu(forView: view, allowsBackForwardNavigationGestures: true)
browser.loadRequest("http://www.elo7.com")
```

#### Delegate methods
Oahu responds to all WKNavigationDelegate methods

```swift
class ViewController: UIViewController, WKNavigationDelegate
```

And then

```swift
browser.navigationDelegate = self
```

## Contritute
- If you **found a bug**, open an issue.
- If you ***have a feature request***, open an issue.
- If you ***want to contribute***, submit a pull request


## License
Oahu is released under the MIT license. See LICENSE for details.
