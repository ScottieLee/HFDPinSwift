// Strategy

protocol Duck {
    var flyBehavior:FlyBehavior { get set }
    var quackBehavior:QuackBehavior { get set }
    func display()
    func performFly()
    func performQuack()
}

extension Duck {
    func performFly() {
        self.flyBehavior.fly()
    }
    func performQuack() {
        self.quackBehavior.quack()
    }
    func swim() {
        print("All ducks float, even decoys")
    }
}

class ModelDuck: Duck {
    var flyBehavior:FlyBehavior = FlyNoWay()
    var quackBehavior:QuackBehavior = Quack()
    func display() {
        print("I'm a model duck")
    }
}

class MallardDuck: Duck {
    var flyBehavior:FlyBehavior = FlyWithWings()
    var quackBehavior:QuackBehavior = Quack()
    func display() {
        print("I'm a mallard duck")
    }
}

protocol FlyBehavior {
    func fly()
}

class FlyNoWay: FlyBehavior {
    func fly() {
        print("I can't fly")
    }
}

class FlyWithWings: FlyBehavior {
    func fly() {
        print("I'm flying")
    }
}

class FlyRocketPowered: FlyBehavior {
    func fly() {
        print("I'm flying with a rocket")
    }
}

protocol QuackBehavior {
    func quack()
}

class Quack: QuackBehavior {
    func quack() {
        print("Quack")
    }
}

class MuteQuack: QuackBehavior {
    func quack() {
        print("Silence")
    }
}

class Squack: QuackBehavior {
    func quack() {
        print("Squack")
    }
}

