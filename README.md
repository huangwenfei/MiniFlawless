## MiniFlawless

- MiniFlawless 是一个动画库。
- MiniFlawless 目前仅支持 iOS。

## 内容

- 要求
- 安装
- 例子

## 要求

- iOS 12+
- Xcode 15+
- Swift 5+


## 安装

- Swift Package
```swift
dependencies: [
    .package(url: "https://github.com/huangwenfei/MiniFlawless.git", .upToNextMajor(from: "0.0.3.3"))
]
```

- Cocoapods
```ruby
pod 'MiniFlawless'
```


## 例子

具体请查看 iOS-Example 工程。

- Tween
```swift
import MiniFlawless

let testView = ...

let item = MiniFlawlessItem<CGFloat>.init(
    name: "Test",
    duration: 0.3,
    from: testView.frame.minY,
    to: testView.frame.minY + 240,
    stepper: .tween(.linear),
    completion: { item in
        print("Done")
    })

let mini = MiniFlawlessAnimator(displayItem: item)
mini.startAnimation()

```


- Spring
```swift
import MiniFlawless

let testView = ...

let item = MiniFlawlessItem<CGFloat>.init(
    name: "Test",
    duration: 0.3,
    from: testView.frame.minY,
    to: testView.frame.minY + 130,
    stepper: .spring(.init()),
    completion: { item in
        print("Done")
    })
    
let mini = MiniFlawlessAnimator(displayItem: item)
mini.startAnimation()
```
