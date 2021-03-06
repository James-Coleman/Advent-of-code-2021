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
}

enum PositionRouter {
    /// Array of positions
    typealias Route = [Position]
    
    enum Error: Swift.Error {
        case emptyPositions
        case nowhereToGo(soFar: Route)
    }
    
    static func naiveRoute(from positions: [Route]) throws -> Route {
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
    
    static func recursiveRouter(from positions: [Route], soFar: Route = []) throws -> [Route]? {
        guard
            let firstRow = positions.first,
            let startingPosition = firstRow.first,
            let lastRow = positions.last,
            let lastPosition = lastRow.last
        else { throw Error.emptyPositions }
        
        let route = soFar.isEmpty ? [startingPosition] : soFar
        
        let currentPosition = route.last ?? startingPosition
        
        let nextPositions = currentPosition.neighbours
            .filter { route.contains($0) == false }
        
        if nextPositions.isEmpty {
            return nil
        } else {
            let test = try nextPositions.compactMap { position -> [Route]? in
                if position == lastPosition {
                    return [soFar + [position]]
                } else {
                    let newRoute = soFar + [position]
                    
                    return try recursiveRouter(from: positions, soFar: newRoute)
                }
            }
            
            return test.flatMap { $0 }
        }
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
//    let naiveRoute = try PositionRouter.naiveRoute(from: examplePositions)
    let recursiveRoutes = try PositionRouter.recursiveRouter(from: examplePositions)
} catch {
    error
}
