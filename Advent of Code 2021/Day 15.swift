//
//  Day 15.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 15/12/2021.
//

import Foundation

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

extension Position: CustomStringConvertible {
    var description: String { "\(coordinate.x) \(coordinate.y) (\(score))" }
}

enum PositionRouter {
    /// Array of positions
    typealias Route = [Position]
    
    enum Error: Swift.Error {
        case emptyPositions
        case nowhereToGo(soFar: Route)
    }
    
    static func debugPrint(_ route: Route, from positions: [[Position]]) {
        var string = ""
        
        for line in positions {
            for position in line {
                if route.contains(position) {
                    string += "■"
                } else {
                    string += "\(position.score)"
                }
            }
            
            string += "\n"
        }
        
        print(string)
        
        let score = route.reduce(0) { soFar, next in
            soFar + next.score
        }
        
        print("Score was \(score)")
    }
    
    static func naiveRoute(from positions: [Route]) throws -> Route {
        guard
            let firstRow = positions.first,
            let startingPosition = firstRow.first,
            let lastRow = positions.last,
            let lastPosition = lastRow.last
        else { throw Error.emptyPositions }
        
        var route = [startingPosition]
        
        var currentPosition = startingPosition
        
        while currentPosition != lastPosition {
            let next = currentPosition.neighbours
                .filter { route.contains($0) == false }
                .sorted(by: { $0.score < $1.score })
                .first
            
            guard let nextPosition = next else { throw Error.nowhereToGo(soFar: route) }
            
            route += [nextPosition]
            currentPosition = nextPosition
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
            let newRoutes = try nextPositions.compactMap { position -> [Route]? in
                if position == lastPosition {
                    let completeRoute = [route + [position]]
                    
                    let score = completeRoute.reduce(0) { soFar, next in
                        soFar + next.map { $0.score }.reduce(0, +)
                    }
                    
                    print("Found a solution with score \(score)\n\(completeRoute)")
                    
                    return completeRoute
                } else {
                    let newRoute = route + [position]
                    
                    return try recursiveRouter(from: positions, soFar: newRoute)
                }
            }
            
            return newRoutes.flatMap { $0 }
        }
    }
}

func day15() {
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
        
        do {
            let naiveRoute = try PositionRouter.naiveRoute(from: examplePositions)
        } catch let PositionRouter.Error.nowhereToGo(soFar) {
            PositionRouter.debugPrint(soFar, from: examplePositions)
        } catch {
            print(error)
        }
        
//        let recursiveRoutes = try PositionRouter.recursiveRouter(from: examplePositions)
//        recursiveRoutes?.forEach { print($0) }
    } catch {
        print(error)
    }

}
