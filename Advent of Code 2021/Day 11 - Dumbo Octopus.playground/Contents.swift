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
    var energyLevel: Int
    var neighbours: [Octopus]
    
    init(energyLevel: Int) {
        self.energyLevel = energyLevel
        self.neighbours = []
    }
}

extension Octopus {
    
    static func nextStep(after octopuses: [[Octopus]]) -> [[Octopus]] {
        // Make an [[Int]] of energy levels to increase by?
        
        var octopuses = octopuses
        
        
        
        return octopuses
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
