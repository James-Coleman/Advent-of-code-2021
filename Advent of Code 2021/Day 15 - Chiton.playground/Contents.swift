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

class Position {
    let coordinate: CGPoint
    let score: Int
    
    var neighbours: [Position] = []
    
    init(coordinate: CGPoint, score: Int) {
        self.coordinate = coordinate
        self.score = score
    }
}

extension Position: Equatable {
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.coordinate == rhs.coordinate
    }
}

extension Position {
    enum Error: Swift.Error {
        case foundNonInteger(Character)
        case emptyPositions
        case nowhereToGo(soFar: [Position])
    }
    
    static func factory(input: String) throws -> [[Position]] {
        var positions = [[Position]]()
        
        let lines = input.components(separatedBy: .newlines)
        
        for (y, line) in lines.enumerated() {
            var positionLine = [Position]()
            
            for (x, character) in line.enumerated() {
                guard let int = Int(String(character)) else { throw Error.foundNonInteger(character) }
                
                let point = CGPoint(x: x, y: y)
                
                let position = Position(coordinate: point, score: int)
                
                positionLine += [position]
            }
            
            positions += [positionLine]
        }
        
        for (y, line) in positions.enumerated() {
            for (x, position) in line.enumerated() {
                let above = positions[safe: y-1]?[safe: x]
                let below = positions[safe: y+1]?[safe: x]
                let left = positions[safe: y]?[safe: x-1]
                let right = positions[safe: y]?[safe: x+1]
                
                position.neighbours = [above, below, left, right].compactMap { $0 }
            }
        }
        
        return positions
    }
    
    static func naiveRoute(from positions: [[Position]]) throws -> [Position] {
        guard
            let firstRow = positions.first,
            let startingPosition = firstRow.first,
            let lastRow = positions.last,
            let lastPosition = lastRow.last
        else { throw Error.emptyPositions }
        
        // Might not need this if we use route.contains(_)
//        let totalCount = positions.reduce(0) { soFar, next in
//            soFar + next.count
//        }
        
        var route = [startingPosition]
        
        var currentPosition = startingPosition
        
        while currentPosition != lastPosition {
            let next = currentPosition.neighbours
                .filter { route.contains($0) == false }
                .sorted(by: { $0.score < $1.score })
                .first
            
            guard let next = next else { throw Error.nowhereToGo(soFar: route) }
            
            route += [next]
            currentPosition = next
        }
        
        return route
    }
}

let exampleInput = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """

do {
    let examplePositions = try Position.factory(input: exampleInput)
    let route = try Position.naiveRoute(from: examplePositions)
} catch {
    error
}
