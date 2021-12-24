import Foundation

var greeting = "Hello, playground"

struct Towers: Hashable {
    var a: [Int] = []
    var b: [Int] = []
    var c: [Int] = []
    
    static let starter3 = Towers(a: [1,2,3])
    static let target3 = Towers(c: [1,2,3])
}

extension Towers: CustomStringConvertible {
    var description: String {
        "\(a) \(b) \(c)"
    }
}

extension Array where Element == Int {
    mutating func popFirst() -> Int? {
        guard self.count > 0 else { return nil }
        
        let first = self[0]
        
        self.removeFirst()
        
        return first
    }
    
    var isInOrder: Bool {
        self.sorted(by: <) == self
    }
}

func towersOfHanoi(towers: Towers) -> Set<Towers> {
    var towersToReturn: Set<Towers> = []
    
    var towersAB = towers
    if let ringAB = towersAB.a.popFirst() {
        towersAB.b.insert(ringAB, at: 0)
        if towersAB.b.isInOrder {
            towersToReturn.insert(towersAB)
        }
    }
    
    var towersAC = towers
    if let ringAC = towersAC.a.popFirst() {
        towersAC.c.insert(ringAC, at: 0)
        if towersAC.c.isInOrder {
            towersToReturn.insert(towersAC)
        }
    }
    
    var towersBA = towers
    if let ringBA = towersBA.b.popFirst() {
        towersBA.a.insert(ringBA, at: 0)
        if towersBA.a.isInOrder {
            towersToReturn.insert(towersBA)
        }
    }
    
    var towersBC = towers
    if let ringBC = towersBC.b.popFirst() {
        towersBC.c.insert(ringBC, at: 0)
        if towersBC.c.isInOrder {
            towersToReturn.insert(towersBC)
        }
    }
    
    var towersCA = towers
    if let ringCA = towersCA.c.popFirst() {
        towersCA.a.insert(ringCA, at: 0)
        if towersCA.a.isInOrder {
            towersToReturn.insert(towersCA)
        }
    }
    
    var towersCB = towers
    if let ringCB = towersCB.c.popFirst() {
        towersCB.b.insert(ringCB, at: 0)
        if towersCB.b.isInOrder {
            towersToReturn.insert(towersCB)
        }
    }
    
    return towersToReturn
}

func hanoiRecursive() {
    var latestGen: Set<Towers> = [.starter3]
    var allGens: Set<Towers> = [.starter3]
    
    var generation = 0
    
    while allGens.contains(.target3) == false && latestGen.isEmpty == false {
        let nextGens = latestGen.flatMap { towersOfHanoi(towers: $0) }
        let nextGensWithoutAlreadyDone = Set(nextGens).subtracting(allGens)
//        print(latestGen)
//        print(nextGens)
        print(nextGensWithoutAlreadyDone)
        allGens.formUnion(nextGens)
        latestGen = nextGensWithoutAlreadyDone
        generation += 1
    }
    
    print(allGens, generation)
}

//hanoiRecursive()

func hanoiRoute(previous: [Towers], target: Towers) -> [Towers] {
    guard let parent = previous.last else { return [] }
    
    let nextGens = towersOfHanoi(towers: parent)
    
    if nextGens.contains(target) {
        return previous + [target]
    } else {
        return nextGens.flatMap { hanoiRoute(previous: previous + [$0], target: target) }
    }
}

//hanoiRoute(previous: [.starter3], target: .target3) // infinite loop

func hanoiRoutes() -> [Towers]? {
    var latestGen: Set<Towers> = [.starter3]
    var allGens: Set<Towers> = [.starter3]
    var routes: [[Towers]] = [[.starter3]]
    
    while true {
        let allNewRoutes = routes.flatMap { route -> [[Towers]] in
            guard let lastTower = route.last else { return [] }
            let nextGens = towersOfHanoi(towers: lastTower)
            let newRoutes = nextGens.compactMap { nextGen -> [Towers]? in
                if route.contains(nextGen) {
                    return nil
                } else {
                    return route + [nextGen]
                }
            }
            return newRoutes
        }
        
        for route in routes {
            if route.last == .target3 {
                return route
            }
        }
        
        routes = allNewRoutes
    }
}

hanoiRoutes()
