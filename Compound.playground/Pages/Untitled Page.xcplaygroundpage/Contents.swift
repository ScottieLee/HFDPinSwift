/*:
# 复合模式
在一个解决方案中结合多个模式，以解决一般或重复发生的问题。
*/
/*:
## 与鸭子重聚
*/
import Foundation
protocol Quackable {
    func quack()
}
//: 绿头鸭
class MallardDuck: Quackable {
    func quack() {
        print("Mallard Duck quack.")
    }
}
//: 红头鸭
class RedHeadDuck: Quackable {
    func quack() {
        print("RedHeadDuck quack.")
    }
}
//: 鸭鸣器
class DuckCall: Quackable {
    func quack() {
        print("Duckcall Kwak")
    }
}
//: 橡皮鸭
class RubberDuck: Quackable {
    func quack() {
        print("RubberDuck squack.")
    }
}
//: 模拟器
class DuckSimulator {
    func simulateAll() {
        let mallard = MallardDuck()
        let redHead = RedHeadDuck()
        let duckCall = DuckCall()
        let rubber = RubberDuck()
        print("\nDuck simulator")
        simulate(mallard)
        simulate(redHead)
        simulate(duckCall)
        simulate(rubber)
    }
    
    func simulate(duck: Quackable) {
        duck.quack()
    }
}
let duckSimulator = DuckSimulator()
duckSimulator.simulateAll()
//: 鹅也在附近
class Goose {
    func honk() {
        print("Goose honk.")
    }
}
/*:
鹅也会飞会叫，和鸭子差不多
我们想要在现有的鸭子模拟器中使用鹅

让不兼容的接口合作
### 适配器模式
将一个接口转换成客户期望的另一个接口

适配目标接口是鸭子，被适配者是鹅。
*/
class GooseAdapter: Quackable /*适配器实现目标接口*/{
    // 适配器与被适配者组合
    private (set) var goose: Goose
    init(goose: Goose) {
        self.goose = goose
    }
    func quack() {
        goose.honk()
    }
}
//: 使用适配器
let gooseQuackable = GooseAdapter(goose: Goose())
gooseQuackable.quack()
/*:
## 咕咕叫学家
研究一群鸭子，会有多少咕咕叫声？

在不改变鸭子类的情况下，计算咕咕叫的次数
### 装饰者模式
动态地将责任附加到对象上。扩展一个类的功能，装饰者提供了比继承能有弹性的替代方案。
*/
class QuackCounter: Quackable {
    private (set) static var totalNumberOfQuacks = 0
    private (set) var duck: Quackable
    init(duck : Quackable) {
        self.duck = duck
    }
    func quack() {
        duck.quack()
        ++QuackCounter.totalNumberOfQuacks
    }
}
//: 使用被装饰的鸭子
/*
class DuckSimulator {
    func simulateAll() {
        let mallard = QuackCounter(duck: MallardDuck())
        let redHead = QuackCounter(duck: RedHeadDuck())
        let duckCall = QuackCounter(duck: DuckCall())
        let rubber = QuackCounter(duck: RubberDuck())
        print("\nDuck simulator")
        simulate(mallard)
        simulate(redHead)
        simulate(duckCall)
        simulate(rubber)
        // total quack time
        print("The ducks quack \(QuackCounter.totalNumberOfQuacks) times")
    }
    
    func simulate(duck: Quackable) {
        duck.quack()
    }
}
let duckSimulator = DuckSimulator()
duckSimulator.simulateAll()
*/

/*:
## 确保产生的鸭子都是包装起来的。
需要质量控制，创建被装饰的鸭子

工厂模式：

定义一个创建对象的接口，由子类决定要实例化的类是哪一个。工厂方法让类把实例化推迟到子类。

生产普通鸭子，也能生产被装饰的鸭子。两个产品线。

绿头鸭，红头鸭，。。它们是是产品族中的不同产品。

抽象工厂模式：

提供一个接口，用于创建相关或依赖的对象家族，而不需要明确指定具体的类。
*/
//: 定义抽象工厂
protocol AbstractFactory {
    func createMallardDuck() -> Quackable
    func createRedHeadDuck() -> Quackable
    func createDuckCall() -> Quackable
    func createRubberDuck() -> Quackable
}
//: 第一个产品线，普通鸭子
class DuckFactory: AbstractFactory {
    func createMallardDuck() -> Quackable {
        return MallardDuck()
    }
    func createRedHeadDuck() -> Quackable {
        return RedHeadDuck()
    }
    func createDuckCall() -> Quackable {
        return DuckCall()
    }
    func createRubberDuck() -> Quackable {
        return RubberDuck()
    }
}
//: 第二个产品线，被装饰的可计数的鸭子
class CountingDuckFactory: AbstractFactory {
    func createMallardDuck() -> Quackable {
        return QuackCounter(duck: MallardDuck())
    }
    func createRedHeadDuck() -> Quackable {
        return QuackCounter(duck: RedHeadDuck())
    }
    func createDuckCall() -> Quackable {
        return QuackCounter(duck: DuckCall())
    }
    func createRubberDuck() -> Quackable {
        return QuackCounter(duck: RubberDuck())
    }
}
//： 让模拟器使用工厂
/*
class DuckSimulator {
    func simulateAllWithFactory(factory: AbstractFactory) {
        let mallard = factory.createMallardDuck()
        let redHead = factory.createRedHeadDuck()
        let duckCall = factory.createDuckCall()
        let rubber = factory.createRubberDuck()
        print("\nDuck simulator")
        simulate(mallard)
        simulate(redHead)
        simulate(duckCall)
        simulate(rubber)
        // total quack time
        print("The ducks quack \(QuackCounter.totalNumberOfQuacks) times")
    }
    
    func simulate(duck: Quackable) {
        duck.quack()
    }
}
let duckSimulator = DuckSimulator()
duckSimulator.simulateAllWithFactory(CountingDuckFactory())
*/
/*:
## 咕咕叫学家：『这么多鸭子，能否帮我们作为一个整体统一管理』
把鸭子视为一个集合，我们下一次命令就让所有鸭子听命行事。

如何向对待单个对象一样对待整个集合？
### 组合模式
允许你将对象组合成树形状结构来表现整体/部分 层次结构。让客户以一致的方式处理个别对象以及整个集合。

组合需要实现和叶子节点一样的接口。这里就是Quackable
*/
class Flock: Quackable {
    private var quackers = [Quackable]()
    func addQuacker(quacker: Quackable) {
        quackers.append(quacker)
    }
    func quack() {
        var iterator = quackers.generate()
        var quacker = iterator.next()
        while quacker != nil {
            quacker!.quack()
            quacker = iterator.next()
        }
    }
}
//: 在模拟器中统一管理quack行为
/*
class DuckSimulator {
    func simulateAllWithFactory(factory: AbstractFactory) {
        let mallard = factory.createMallardDuck()
        let redHead = factory.createRedHeadDuck()
        let duckCall = factory.createDuckCall()
        let rubber = factory.createRubberDuck()
        
        // 主群落
        let flockOfDucks = Flock()
        flockOfDucks.addQuacker(mallard)
        flockOfDucks.addQuacker(redHead)
        flockOfDucks.addQuacker(duckCall)
        flockOfDucks.addQuacker(rubber)
        
        //绿头鸭群落
        let mallardFlock = Flock()
        mallardFlock.addQuacker(factory.createMallardDuck())
        mallardFlock.addQuacker(factory.createMallardDuck())
        mallardFlock.addQuacker(factory.createMallardDuck())
        
        //把绿头鸭群落加入主群落
        flockOfDucks.addQuacker(mallardFlock)
        
        print("\nDuck simulator")
        simulate(flockOfDucks)
        // total quack time
        print("The ducks quack \(QuackCounter.totalNumberOfQuacks) times")
    }
    
    func simulate(duck: Quackable) {
        duck.quack()
    }
}
let duckSimulator = DuckSimulator()
duckSimulator.simulateAllWithFactory(CountingDuckFactory())
*/
/*:
## 咕咕叫学家：『我们也需要追踪个别鸭子的咕咕叫』

### 观察者模式
定义了对象之间的一对多以来，当一个对象改变时，关联的所有依赖者都会收到通知并自动更新
quackable是被观察对象
咕咕叫学家是observer
*/
//: 定义obserable接口
protocol QuackObservable {
    func registerObserver(observer: Observer)
    func notifyObservers()
}
//: Quackable实现observable接口
//: 或者委托给一个Observable对象
class Weak{
    weak var value : AnyObject?
    init (value: AnyObject) {
        self.value = value
    }
}
class Observable: QuackObservable {
    var observers = [Weak] ()
    func registerObserver(observer: Observer) {
        observers.append(Weak(value: observer))
    }
    func notifyObservers() {
        for each in observers {
            (each.value as! Observer).update(self)
        }
    }
}
//: 每个Duck都需要委托Observable对象处理注册与通知

/*
class MallardDuck: Quackable {
    func quack() {
        print("Mallard Duck quack.")
        
    }
    let observable = Observable()
    func registerObserver(observer: Observer) {
        self.observable.registerObserver(observer)
    }
    func notifyObservers() {
        self.observable.notifyObservers()
    }
}
*/

//: Observer接口
protocol Observer: AnyObject{
    func update(observable: QuackObservable)
}
//: 咕咕叫学家是Observer
class Quackologist: Observer {
    func update(observable: QuackObservable) {
        print("Quackologist: \(observable) just quacked")
    }
}

/*
class DuckSimulator {
    
    func simulateAllWithFactory(factory: AbstractFactory) {
        let mallard = factory.createMallardDuck()
        let redHead = factory.createRedHeadDuck()
        let duckCall = factory.createDuckCall()
        let rubber = factory.createRubberDuck()
        
        // 创建observer
        let quackologist = Quackologist()
        // 主群落
        let flockOfDucks = Flock()
        flockOfDucks.addQuacker(mallard)
        flockOfDucks.addQuacker(redHead)
        flockOfDucks.addQuacker(duckCall)
        flockOfDucks.addQuacker(rubber)
        flockOfDucks.registerObserver(quackologist)
        
        //绿头鸭群落
        let mallardFlock = Flock()
        mallardFlock.addQuacker(factory.createMallardDuck())
        mallardFlock.addQuacker(factory.createMallardDuck())
        mallardFlock.addQuacker(factory.createMallardDuck())
        
        //把绿头鸭群落加入主群落
        flockOfDucks.addQuacker(mallardFlock)
        
        print("\nDuck simulator")
        simulate(flockOfDucks)
        // total quack time
        print("The ducks quack \(QuackCounter.totalNumberOfQuacks) times")
    }
    func simulate(duck: Quackable) {
        duck.quack()
    }
}
let duckSimulator = DuckSimulator()
duckSimulator.simulateAllWithFactory(DuckFactory())
*/
