//
//  MiniFlawlessItemList+ItemLink.swift
//  MiniFlawless
//
//  Created by 黄文飞 on 2021/12/5.
//

import Foundation

public protocol MiniFlawlessItemListLinkable { }

public struct MiniFlawlessItemListItemLinkValue<Element: MiniFlawlessSteppable> {
    
    public var value: Element? = nil
    
    public typealias Mode = MiniFlawlessItemListItemLinkValueMode<Element>
    public var valueMode: Mode? = nil

    public init(value: Element) {
        self.value = value
    }
    
    public init(mode: Mode) {
        self.valueMode = mode
    }
    
    public func value(_ previous: Element) -> Element {
//        // TODO: 计算当前值
//        #warning("计算当前值")
        fatalError("没有实现")
    }
    
}

public enum MiniFlawlessItemListItemLinkValueMode<Element: MiniFlawlessSteppable> {
    
    /// - Tag: Translate
    case increase(Element)
    case decrease(Element)
    
    /// - Tag: Scale
    case multiplyBy(Double)
    case dividedBy(Double)
    
    /// - Tag: Sign
    case negative
    case positive
    
    /// - Tag: Reverse
    /// 如果 Element 内只有一个元素，如：Int / CGFloat 等，reverse 无效
    /// 如果 Element 内有两个或以上的元素，则会正向元素变成反向元素，如： CGPoint { x: 7, y: 10 } -> CGPoint { x: 10, y: 7 }
    case reverse
    
}

public final class MiniFlawlessItemListLinkContainer<Element: MiniFlawlessSteppable>: CustomStringConvertible {
    
    public typealias LinkItem = MiniFlawlessItemListLinkable
    public typealias LinkItems = [LinkItem]
    
    public var items: LinkItems = []
    
    public var description: String {
        items.description
    }
    
    internal init() { }
    
    internal func add(_ new: LinkItem) {
        items.append(new)
    }
    
    public static func virtualHead() -> Self {
        .init()
    }
    
    public typealias Item = MiniFlawlessItemListItemLink<Element>
    
    public func element(_ value: Element) -> Item {
        let start = Item.init(value: value, container: self)
        items.append(start)
        return start
    }
    
    public static func elements(_ closure: (Self) -> Void) -> Self {
        let instance = virtualHead()
        closure(instance)
        return instance
    }
    
}

/// 后面可以连接一个 Stepper / Duration / Completion
public final class MiniFlawlessItemListItemLink<Element: MiniFlawlessSteppable>: MiniFlawlessItemListLinkable, CustomStringConvertible {
    
    public typealias Container = MiniFlawlessItemListLinkContainer<Element>
    internal var container: Container
    
    public typealias Value = MiniFlawlessItemListItemLinkValue<Element>
    public typealias ValueMode = Value.Mode
    
    public var value: Value
    
    public var description: String {
        String(describing: value)
    }
    
    internal init(value: Element, container: Container) {
        self.value = .init(value: value)
        self.container = container
    }
    
    internal init(value: ValueMode, container: Container) {
        self.value = .init(mode: value)
        self.container = container
    }
    
    public typealias Duration = MiniFlawlessItemListTimeIntervalLink<Element>
    
    public func timeInterval(_ value: TimeInterval) -> Duration {
        let item = Duration.init(timeInterval: value, container: container)
        container.items.append(item)
        return item
    }
    
    public typealias Step = MiniFlawlessItemListStepLink<Element>
    
    public func timeFunction(_ mode: Step.Mode) -> Step {
        let stepper = Step.init(mode: mode, container: container)
        container.items.append(stepper)
        return stepper
    }
    
    public typealias Done = MiniFlawlessItemListCompletionLink<Element>
    
    @discardableResult
    public func completion(_ value: @escaping MiniFlawlessItemList<Element>.Completion) -> Done {
        let item = Done.init(completion: value, container: container)
        container.items.append(item)
        return item
    }
    
    public func commit() -> Container {
        container
    }
    
}

/// 后面必须要连接一个 Element
public final class MiniFlawlessItemListStepLink<Element: MiniFlawlessSteppable>: MiniFlawlessItemListLinkable, CustomStringConvertible {
    
    public typealias Container = MiniFlawlessItemListLinkContainer<Element>
    internal var container: Container
    
    public typealias Mode = AnyStepperConfiguration<Element>.Mode
    public var mode: Mode
    
    public var description: String {
        String(describing: mode)
    }
    
    public init(mode: Mode, container: Container) {
        self.mode = mode
        self.container = container
    }
    
    public typealias Item = MiniFlawlessItemListItemLink<Element>
    
    public func element(_ value: Element) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
    public func element(_ value: Item.ValueMode) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
    public typealias Duration = MiniFlawlessItemListTimeIntervalLink<Element>

    public func timeInterval(_ value: TimeInterval) -> Duration {
        let item = Duration.init(timeInterval: value, container: container)
        container.items.append(item)
        return item
    }
    
}

/// 后面必须要连接一个 Element 或 Stepper
public final class MiniFlawlessItemListTimeIntervalLink<Element: MiniFlawlessSteppable>: MiniFlawlessItemListLinkable, CustomStringConvertible {
    
    public typealias Container = MiniFlawlessItemListLinkContainer<Element>
    internal var container: Container
    
    public var timeInterval: TimeInterval
    
    public var description: String {
        String(describing: timeInterval)
    }
    
    public init(timeInterval: TimeInterval, container: Container) {
        self.timeInterval = timeInterval
        self.container = container
    }
    
    public typealias Step = MiniFlawlessItemListStepLink<Element>
    
    public func timeFunction(_ mode: Step.Mode) -> Step {
        let stepper = Step.init(mode: mode, container: container)
        container.items.append(stepper)
        return stepper
    }
    
    public typealias Item = MiniFlawlessItemListItemLink<Element>
    
    public func element(_ value: Element) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
    public func element(_ value: Item.ValueMode) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
}

/// 后面必须要连接一个 Element, 或者 直接 Commit
public final class MiniFlawlessItemListCompletionLink<Element: MiniFlawlessSteppable>: MiniFlawlessItemListLinkable, CustomStringConvertible {
    
    public typealias Container = MiniFlawlessItemListLinkContainer<Element>
    internal var container: Container
    
    public typealias Completion = MiniFlawlessItemList<Element>.Completion
    public var completion: Completion
    
    public var description: String {
        String(describing: completion)
    }
    
    public init(completion: @escaping Completion, container: Container) {
        self.completion = completion
        self.container = container
    }
    
    public typealias Item = MiniFlawlessItemListItemLink<Element>
    
    public func element(_ value: Element) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
    public func element(_ value: Item.ValueMode) -> Item {
        let item = Item.init(value: value, container: container)
        container.items.append(item)
        return item
    }
    
    public func commit() -> Container {
        container
    }
    
}

#if false
func test() {
    let _ = MiniFlawlessItemListLinkContainer<Int>
        .virtualHead()
        .element(8)
        .timeInterval(0.1)
        .timeFunction(.tween(.init(function: .linear)))
        .element(13)
        .completion({ _ in })
        .commit()
}
#endif

#if true
func tt() {
    typealias Container = MiniFlawlessItemListLinkContainer<Double>
    let closure: (Container) -> Void = {
        $0
            .element(8)
            .timeInterval(0.1)
            .timeFunction(.tween(.init(function: .linear)))
            .element(.increase(30))
            .completion({ _ in })
    }
    let _ = Container.elements(closure)
}
#endif
