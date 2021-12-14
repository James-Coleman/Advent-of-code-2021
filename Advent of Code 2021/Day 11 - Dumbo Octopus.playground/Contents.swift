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
    
    var incrementedBy: Set<Octopus> = []
    
    init(energyLevel: Int) {
        self.energyLevel = energyLevel
    }
    
    /**
     - returns: `true` if the new value will mean the Octopus is flashing
     */
    func prepareNextStep() -> Bool {
//        incrementAmount += 1 // This is now done by the static func before looping this function
        
        if energyLevel + incrementAmount <= 9 {
            let highEnergyNeighbours = Set(neighbours.filter { $0.energyLevel + $0.incrementAmount >= 9 })
            let notYetUsedToIncrement = highEnergyNeighbours.subtracting(incrementedBy)
            
            incrementAmount += notYetUsedToIncrement.count
            
            incrementedBy.formUnion(notYetUsedToIncrement)
            
            return energyLevel + incrementAmount > 9
        }
        
        return false
    }
    
    func commitNextStep() {
        let total = energyLevel + incrementAmount
        
        if total > 9 {
            energyLevel = 0
        } else {
            energyLevel = total
        }
        
        incrementAmount = 0
        
        incrementedBy = []
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
    
    static func increment(octopuses: [[Octopus]]) {
        // Make an [[Int]] of energy levels to increase by?
        
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
                    let result = octopus.prepareNextStep()
                    
                    if result {
                        someoneLocallyFlashed = true
                    }
                }
            }
            
            someoneFlashed = someoneLocallyFlashed
        } while someoneFlashed
        
        for line in octopuses {
            for octopus in line {
                octopus.commitNextStep()
            }
        }
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
Octopus.increment(octopuses: largerExampleOctopuses)
Octopus.debugPrint(largerExampleOctopuses)
Octopus.increment(octopuses: largerExampleOctopuses)
Octopus.debugPrint(largerExampleOctopuses)
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
