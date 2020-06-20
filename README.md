<H1 align="center"> RetroObjective</H1>  

<H4 align="center">Proxy for receive delegate events more practically</H4>

---

## About RetroObjective
__RetroObjective__ enable you to receive delegate events by subscribed handler.

This is swift 5 and later generic version of DelegateProxy by [DelegateProxy](https://github.com/ra1028/DelegateProxy)

---

## Requirements
- Swift 5 / Xcode 9
- OS X 10.12 or later
- iOS 10.0 or later
- watchOS 3.0 or later
- tvOS 10.0 or later

---

## Installation

### [CocoaPods](https://cocoapods.org/)  
Add the following to your Podfile:
```ruby
use_frameworks!

target 'YOUR_TARGET_NAME' do
  pod 'RetroObjective', :git => 'https://github.com/amine2233/RetroObjective.git'
end
```
```sh
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your Cartfile:
```ruby
github "amine2233/RetroObjective"
```
```sh
$ carthage update
```

---

## Basic Example
Create `RetroObjective` inherited class.
```Swift
final class ScrollViewDelegateProxy: RetroObjective, UIScrollViewDelegate, RetroObjectiveType {
    func resetDelegateProxy(owner: UIScrollView) {
        owner.delegate = self
    }
}
```
It can be useful to implements extension.
```Swift
extension UIScrollView {
    var delegateProxy: ScrollViewDelegateProxy {
        return .proxy(for: self)
    }
}
```
You can receive delegate events as following.
```Swift
scrollView.delegateProxy
    .receive(#selector(UIScrollViewDelegate.scrollViewDidScroll(_:))) { args in
        guard let scrollView: UIScrollView = args.value(at: 0) else { return }
        print(scrollView.contentOffset)
}
```
## Basic Example with Combine

You can add a new publisher on UIScrollView

```Swift
extension UISCrollView {
    var value: AnyPublisher<UISCrollView, Never> {
        Publishers.proxyDelegate(delegateProxy, selector: #selector(UIScrollViewDelegate.scrollViewDidScroll(_:)))
            .compactMap { $0.value(at: 0) as? UISCrollView }
            .eraseToAnyPublisher()
    }
}
```

## Contribution  
Welcome to fork and submit pull requests!!

Before submitting pull request, please ensure you have passed the included tests.
If your pull request including new function, please write test cases for it.

---

## License  
DelegateProxy is released under the MIT License.
