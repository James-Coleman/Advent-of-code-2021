import Foundation

var greeting = "Hello, playground"

extension Collection {
    subscript (safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}

class Octopus {
    let id = UUID()
    
    var energyLevel: Int
    
    var neighbours: [Octopus] = []
    
    var incrementAmount = 0
    
    var affectedNeighbours: Set<Octopus> = []
    
    init(energyLevel: Int) {
        self.energyLevel = energyLevel
    }
    
    /**
     - returns: `true` if a new neighbour was made to flash.
     */
    func affectNeighbours() -> Bool {
        if energyLevel + incrementAmount > 9 {
            var madeSomeoneFlash = false
            
            let notYetFlashing = Set(neighbours.filter { $0.energyLevel + $0.incrementAmount <= 9 })
            
            let unaffectedNeighbours = notYetFlashing.subtracting(affectedNeighbours)
            
            for neighbour in unaffectedNeighbours {
                neighbour.incrementAmount += 1
                
                if neighbour.energyLevel + neighbour.incrementAmount > 9 {
                    madeSomeoneFlash = true
                }
            }
            
            affectedNeighbours.formUnion(unaffectedNeighbours)
            
            return madeSomeoneFlash
        }
        
        return false
    }
    
    /**
     - returns: `true` if the Octopus flashed.
     */
    func commitNextStep() -> Bool {
        var flashed = false
        
        let total = energyLevel + incrementAmount
        
        if total > 9 {
            energyLevel = 0
            flashed = true
        } else {
            energyLevel = total
        }
        
        incrementAmount = 0
        affectedNeighbours = []
        
        return flashed
    }
}

extension Octopus: Hashable {
    static func ==(lhs: Octopus, rhs: Octopus) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Octopus {
    /**
     - returns: The number of Octopuses that flashed during the increment.
     */
    static func increment(octopuses: [[Octopus]]) -> Int {
        for line in octopuses {
            for octopus in line {
                octopus.incrementAmount += 1
            }
        }
        
        var someoneFlashed = false
        
        repeat {
            var someoneLocallyFlashed = false
            
            for line in octopuses {
                for octopus in line {
                    let result = octopus.affectNeighbours()
                    
                    if result {
                        someoneLocallyFlashed = true
                    }
                }
            }
            
            someoneFlashed = someoneLocallyFlashed
        } while someoneFlashed
        
        var flashers = 0
        
        for line in octopuses {
            for octopus in line {
                let flashed = octopus.commitNextStep()
                
                if flashed {
                    flashers += 1
                }
            }
        }
        
        return flashers
    }
    
    static func flasherCount(of octopuses: [[Octopus]], after generation: Int, debugPrint shouldDebugPrint: Bool = false) -> Int {
        var sum = 0
        
        for _ in 1...generation {
            let flasherCount = increment(octopuses: octopuses)
            sum += flasherCount
            if shouldDebugPrint {
                debugPrint(octopuses)
            }
        }
        
        return sum
    }

    static func factory(input: String) -> [[Octopus]] {
        let octopuses = input
            .components(separatedBy: .newlines)
            .map {
                $0.compactMap {
                    Int(String($0))
                }.map {
                    Octopus(energyLevel: $0)
                }
            }
        
        for (y, line) in octopuses.enumerated() {
            for (x, octopus) in line.enumerated() {
                let above = octopuses[safe: y - 1]?[safe: x]
                let below = octopuses[safe: y + 1]?[safe: x]
                let left = octopuses[safe: y]?[safe: x - 1]
                let right = octopuses[safe: y]?[safe: x + 1]
                let aboveLeft = octopuses[safe: y - 1]?[safe: x - 1]
                let aboveRight = octopuses[safe: y - 1]?[safe: x + 1]
                let belowLeft = octopuses[safe: y + 1]?[safe: x - 1]
                let belowRight = octopuses[safe: y + 1]?[safe: x + 1]
                
                octopus.neighbours = [above, below, left, right, aboveRight, aboveLeft, belowLeft, belowRight].compactMap { $0 }
            }
        }
        
        return octopuses
    }
    
    static func debugPrint(_ octopuses: [[Octopus]]) {
        let string = octopuses.reduce("") { soFar, next in
            soFar + next.reduce("") { soFar2, octopus in
                soFar2 + String(octopus.energyLevel)
            } + "\n"
        }
        
        print(string)
    }
}

extension Octopus: CustomStringConvertible {
    var description: String { String(energyLevel) }
}

let detailedExample = """
    11111
    19991
    19191
    19991
    11111
    """

let detailedExampleOctopuses = Octopus.factory(input: detailedExample)
Octopus.debugPrint(detailedExampleOctopuses)
Octopus.increment(octopuses: detailedExampleOctopuses)
Octopus.debugPrint(detailedExampleOctopuses) // correct
Octopus.increment(octopuses: detailedExampleOctopuses)
Octopus.debugPrint(detailedExampleOctopuses) // correct

let largerExample = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """

let largerExampleOctopuses = Octopus.factory(input: largerExample)
Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses) // correct
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses) // correct
//
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)
//Octopus.increment(octopuses: largerExampleOctopuses)
//Octopus.debugPrint(largerExampleOctopuses)

Octopus.flasherCount(of: largerExampleOctopuses, after: 10, debugPrint: true) // 204 (correct)
