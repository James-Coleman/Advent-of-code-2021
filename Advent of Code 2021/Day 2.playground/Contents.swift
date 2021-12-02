import Cocoa

enum Direction {
    case forward(Int)
    case down(Int)
    case up(Int)
    
    enum Error: Swift.Error {
        case not2Components(Int)
        case numberNotInt(String)
        case unknownDirection(String)
    }
    
    /**
     - throws: `Direction.Error`
     */
    init(_ string: String) throws {
        let components = string.components(separatedBy: .whitespaces)
        
        guard components.count == 2 else { throw Error.not2Components(components.count) }
        
        guard let int = Int(components[1]) else { throw Error.numberNotInt(components[1]) }
        
        switch components[0] {
            case "forward":
                self = .forward(int)
            case "down":
                self = .down(int)
            case "up":
                self = .up(int)
            default:
                throw Error.unknownDirection(components[0])
        }
    }
    
    var point: CGPoint {
        switch self {
            case let .forward(int):
                return CGPoint(x: int, y: 0)
            case let .down(int):
                return CGPoint(x: 0, y: int)
            case let .up(int):
                return CGPoint(x: 0, y: -int)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x,
                y: lhs.y + rhs.y)
    }
}

// MARK: Example

let exampleInput = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """

let exampleArray = exampleInput.components(separatedBy: .newlines)

do {
    let exampleDirectionArray = try exampleArray.map { try Direction($0) }
    let endPoint = exampleDirectionArray.reduce(CGPoint.zero) { soFar, next in
        soFar + next.point
    }
    endPoint
    endPoint.x * endPoint.y // 150 (correct)
} catch {
    print(error)
}

// MARK: Part 1

let puzzleInput = """
    forward 8
    down 6
    down 8
    forward 7
    down 5
    up 2
    down 3
    down 7
    down 8
    down 8
    down 8
    down 2
    up 1
    down 3
    up 2
    down 4
    down 2
    forward 6
    forward 4
    down 3
    down 2
    forward 2
    forward 1
    forward 4
    forward 5
    forward 8
    down 1
    down 4
    up 5
    up 2
    forward 3
    down 9
    forward 7
    forward 9
    forward 9
    forward 8
    down 1
    down 2
    forward 7
    down 3
    forward 6
    down 4
    forward 7
    down 1
    up 8
    forward 3
    down 1
    forward 7
    up 1
    forward 8
    up 6
    up 2
    down 6
    forward 1
    up 6
    forward 5
    down 9
    up 5
    forward 7
    forward 9
    down 9
    down 3
    forward 7
    forward 8
    forward 3
    forward 9
    forward 7
    down 3
    down 7
    down 4
    forward 2
    down 7
    down 3
    down 5
    up 1
    down 9
    up 4
    forward 1
    up 9
    down 2
    forward 8
    down 8
    down 6
    forward 7
    down 9
    down 3
    forward 8
    forward 3
    down 6
    down 7
    down 4
    forward 3
    down 3
    down 9
    forward 8
    forward 9
    up 5
    forward 1
    down 3
    down 3
    down 3
    down 9
    down 2
    down 9
    forward 5
    up 3
    up 5
    up 7
    down 2
    down 7
    down 9
    down 5
    down 4
    down 8
    forward 1
    up 8
    up 3
    forward 1
    forward 5
    forward 3
    up 7
    down 9
    down 9
    forward 7
    down 1
    forward 1
    forward 8
    forward 6
    down 1
    down 7
    forward 9
    up 4
    forward 8
    up 6
    forward 3
    down 3
    down 9
    forward 5
    up 3
    down 7
    forward 9
    forward 2
    up 1
    forward 7
    up 8
    forward 7
    forward 1
    up 3
    up 7
    down 1
    forward 5
    up 8
    down 2
    up 2
    up 3
    down 5
    forward 6
    up 8
    down 7
    up 8
    up 4
    down 8
    forward 9
    down 8
    down 2
    up 7
    down 5
    forward 1
    up 1
    down 1
    forward 1
    forward 1
    forward 3
    forward 8
    down 4
    down 5
    forward 9
    up 6
    up 7
    down 8
    forward 8
    down 2
    forward 6
    down 3
    forward 9
    forward 5
    up 7
    down 2
    up 6
    up 6
    down 9
    forward 3
    up 1
    up 2
    forward 9
    down 1
    up 3
    forward 4
    forward 9
    down 3
    down 4
    forward 4
    up 6
    up 5
    forward 2
    down 5
    down 1
    forward 9
    down 7
    up 6
    up 5
    forward 4
    forward 9
    down 6
    forward 1
    up 6
    down 1
    forward 4
    up 9
    down 6
    forward 5
    down 2
    forward 8
    forward 9
    down 7
    down 4
    down 1
    forward 1
    down 4
    down 6
    forward 5
    forward 2
    forward 8
    forward 5
    down 6
    up 9
    forward 2
    down 1
    forward 6
    forward 6
    down 5
    forward 5
    down 8
    forward 3
    down 5
    up 1
    forward 4
    down 5
    down 4
    forward 4
    down 3
    down 5
    down 7
    forward 5
    forward 2
    up 2
    up 4
    forward 7
    down 3
    down 1
    down 7
    up 8
    forward 6
    forward 3
    forward 7
    forward 5
    up 5
    down 3
    down 6
    forward 7
    up 9
    up 5
    forward 2
    down 9
    forward 8
    forward 6
    forward 5
    up 5
    down 9
    down 8
    up 2
    up 4
    forward 5
    forward 2
    up 4
    forward 3
    down 7
    forward 8
    forward 1
    forward 9
    forward 6
    up 7
    up 2
    forward 1
    down 5
    forward 9
    down 8
    down 4
    down 7
    up 2
    down 5
    forward 7
    up 3
    forward 6
    down 2
    forward 8
    forward 8
    up 3
    forward 6
    forward 9
    forward 8
    forward 3
    up 9
    forward 9
    down 6
    forward 5
    forward 8
    up 1
    forward 2
    forward 6
    forward 8
    up 6
    down 3
    down 9
    down 6
    up 7
    forward 6
    forward 1
    forward 1
    forward 7
    down 5
    down 9
    down 3
    up 3
    forward 3
    forward 2
    down 5
    up 4
    forward 1
    down 9
    forward 9
    forward 1
    forward 1
    down 9
    down 2
    forward 4
    forward 9
    down 5
    up 5
    down 6
    forward 8
    down 4
    down 1
    up 5
    up 3
    down 2
    down 3
    forward 8
    forward 5
    forward 9
    down 4
    up 9
    down 1
    forward 2
    down 8
    up 2
    down 8
    up 6
    forward 7
    down 1
    up 7
    down 9
    forward 9
    down 9
    forward 7
    forward 4
    down 5
    up 3
    down 3
    forward 8
    down 3
    down 4
    down 9
    forward 4
    up 4
    forward 6
    down 1
    forward 5
    down 2
    forward 6
    down 4
    down 1
    forward 3
    up 3
    up 3
    forward 8
    forward 6
    forward 6
    down 9
    forward 5
    down 9
    forward 6
    forward 3
    up 4
    forward 6
    down 8
    up 3
    down 9
    down 3
    forward 6
    down 4
    down 8
    down 6
    down 5
    forward 1
    down 3
    forward 9
    down 9
    down 3
    forward 9
    down 2
    forward 3
    up 6
    forward 2
    forward 1
    forward 8
    down 2
    down 2
    down 7
    up 7
    forward 3
    up 2
    up 6
    up 6
    down 2
    forward 2
    forward 2
    down 6
    down 2
    up 6
    forward 4
    down 9
    up 3
    down 4
    forward 7
    up 6
    forward 3
    forward 1
    down 1
    down 8
    down 8
    down 1
    forward 2
    down 6
    down 6
    forward 2
    up 6
    down 2
    up 4
    down 1
    up 8
    up 5
    down 4
    forward 2
    forward 2
    down 2
    forward 9
    down 5
    down 9
    forward 6
    down 9
    down 5
    down 7
    down 3
    up 9
    down 6
    up 6
    up 8
    forward 8
    forward 8
    down 3
    up 9
    forward 9
    forward 8
    forward 6
    down 4
    down 6
    up 9
    down 9
    down 5
    up 2
    up 2
    forward 2
    forward 1
    down 5
    down 8
    up 3
    forward 2
    down 1
    down 9
    forward 7
    forward 5
    up 3
    up 6
    down 5
    up 1
    down 2
    up 7
    forward 1
    down 6
    up 6
    up 1
    up 2
    forward 2
    down 4
    up 1
    up 3
    up 9
    up 7
    forward 4
    down 5
    down 9
    down 8
    forward 1
    down 4
    forward 4
    forward 8
    up 4
    down 8
    down 1
    down 9
    down 5
    forward 3
    forward 8
    up 2
    down 6
    up 6
    forward 5
    down 6
    down 8
    forward 6
    down 6
    up 5
    down 2
    up 5
    down 7
    down 9
    forward 3
    down 8
    forward 1
    forward 5
    forward 2
    down 4
    forward 2
    forward 7
    up 7
    up 3
    down 2
    forward 7
    up 6
    forward 6
    forward 1
    down 4
    down 2
    down 6
    down 1
    forward 1
    forward 8
    down 1
    up 2
    down 2
    down 1
    down 6
    forward 7
    forward 6
    forward 5
    down 1
    down 8
    down 1
    up 5
    forward 6
    forward 5
    up 5
    forward 5
    up 8
    down 3
    forward 1
    forward 6
    up 8
    up 9
    down 7
    down 1
    forward 2
    forward 1
    forward 9
    forward 3
    forward 7
    forward 8
    down 6
    up 5
    down 1
    forward 1
    forward 8
    down 6
    forward 7
    forward 8
    down 7
    down 5
    down 7
    up 7
    down 5
    forward 5
    down 4
    down 7
    forward 6
    forward 5
    forward 6
    forward 7
    up 9
    down 2
    down 2
    down 4
    down 8
    up 3
    down 7
    down 5
    forward 6
    down 9
    down 5
    down 9
    down 1
    forward 6
    up 7
    down 2
    down 2
    forward 8
    forward 1
    down 3
    down 4
    forward 3
    forward 4
    down 1
    forward 9
    up 7
    forward 8
    down 9
    forward 7
    forward 6
    forward 2
    down 8
    up 9
    down 2
    forward 8
    up 7
    down 5
    down 9
    down 3
    down 6
    down 4
    up 2
    down 3
    down 1
    up 1
    up 6
    forward 4
    down 1
    forward 1
    up 4
    forward 4
    forward 3
    forward 8
    forward 9
    forward 9
    down 2
    down 5
    up 8
    up 1
    down 9
    forward 5
    down 1
    up 5
    down 4
    up 3
    forward 9
    up 7
    forward 9
    up 1
    forward 4
    forward 8
    up 6
    down 6
    down 8
    down 8
    down 9
    down 2
    up 7
    forward 9
    up 8
    down 9
    up 6
    forward 4
    up 7
    down 6
    up 7
    down 4
    forward 2
    forward 9
    down 6
    down 8
    forward 6
    forward 3
    down 3
    forward 3
    forward 7
    up 2
    down 8
    forward 7
    down 5
    down 1
    down 6
    down 5
    down 2
    up 6
    forward 7
    forward 6
    down 1
    down 5
    forward 7
    forward 3
    down 9
    down 8
    forward 5
    up 7
    forward 1
    up 5
    down 7
    forward 8
    forward 6
    forward 2
    down 1
    down 9
    up 1
    down 2
    down 2
    down 7
    down 4
    forward 1
    down 3
    down 5
    up 8
    forward 7
    up 5
    down 8
    down 6
    down 3
    down 3
    down 9
    down 7
    forward 4
    up 5
    forward 3
    forward 7
    down 3
    up 6
    forward 4
    forward 4
    down 4
    down 2
    up 1
    forward 8
    forward 3
    up 1
    forward 1
    down 9
    down 6
    up 1
    down 4
    down 8
    up 9
    forward 2
    down 3
    forward 8
    down 6
    down 5
    down 4
    up 5
    down 9
    up 3
    forward 4
    down 9
    down 7
    forward 6
    forward 6
    forward 8
    forward 6
    down 9
    down 1
    forward 3
    forward 9
    forward 4
    up 8
    up 5
    up 2
    down 9
    forward 9
    forward 3
    forward 5
    up 8
    down 2
    down 1
    forward 9
    forward 7
    down 7
    forward 1
    down 5
    down 8
    down 4
    down 7
    down 1
    down 4
    down 7
    forward 2
    down 5
    forward 1
    down 4
    down 5
    down 2
    up 5
    forward 9
    down 5
    forward 1
    down 7
    down 4
    down 7
    down 6
    forward 5
    down 3
    down 1
    up 2
    forward 2
    forward 2
    forward 1
    down 1
    forward 3
    forward 5
    forward 4
    down 7
    forward 7
    down 1
    forward 7
    forward 5
    down 8
    forward 6
    forward 6
    forward 6
    forward 7
    up 9
    down 4
    down 1
    down 8
    forward 7
    up 4
    forward 4
    down 6
    up 1
    forward 5
    forward 2
    down 1
    forward 7
    forward 6
    forward 5
    forward 2
    down 5
    down 6
    down 9
    up 4
    forward 6
    forward 2
    down 5
    down 3
    up 4
    down 6
    up 8
    forward 8
    up 9
    forward 6
    forward 6
    up 5
    down 7
    forward 9
    forward 6
    down 9
    down 9
    up 1
    forward 7
    down 6
    up 4
    down 8
    down 3
    forward 9
    forward 5
    forward 9
    down 2
    forward 3
    down 1
    forward 9
    up 4
    up 8
    forward 6
    down 1
    forward 9
    forward 4
    down 5
    forward 2
    up 3
    forward 5
    up 8
    up 7
    down 8
    forward 4
    down 6
    forward 7
    up 2
    down 2
    forward 4
    down 9
    down 8
    forward 2
    forward 2
    down 2
    down 3
    forward 3
    down 1
    forward 8
    down 7
    up 9
    down 4
    down 2
    down 5
    up 7
    down 8
    down 2
    down 4
    down 4
    down 8
    forward 7
    forward 7
    down 8
    up 2
    up 3
    forward 8
    up 1
    down 7
    forward 7
    down 6
    down 8
    up 6
    forward 5
    forward 3
    down 6
    forward 9
    up 4
    up 7
    forward 4
    down 1
    down 8
    down 1
    forward 9
    down 3
    forward 8
    forward 6
    forward 4
    down 9
    forward 3
    up 5
    up 8
    down 9
    down 5
    down 1
    up 8
    forward 8
    up 6
    forward 2
    down 8
    up 4
    up 7
    forward 7
    forward 5
    forward 9
    forward 2
    up 4
    down 9
    forward 7
    down 6
    down 6
    forward 7
    down 5
    up 6
    down 9
    forward 3
    """

let puzzleArray = puzzleInput.components(separatedBy: .newlines)

do {
    let puzzleDirectionArray = try puzzleArray.map { try Direction($0) }
    let endPoint = puzzleDirectionArray.reduce(CGPoint.zero) { soFar, next in
        soFar + next.point
    }
    endPoint
    endPoint.x * endPoint.y // 2039912 (correct)
} catch {
    print(error)
}

// MARK: Part 2

struct Submarine {
    var aim = 0
    var position = CGPoint.zero
    
    mutating func apply(direction: Direction) {
        switch direction {
            case let .forward(int):
                position.x += CGFloat(int)
                let deltaY = aim * int
                position.y += CGFloat(deltaY)
            case let .up(int):
                aim -= int
            case let .down(int):
                aim += int
        }
    }
}

var exampleSubmarine = Submarine()

do {
    let exampleDirectionArray = try exampleArray.map { try Direction($0) }
    exampleDirectionArray.forEach { direction in
        exampleSubmarine.apply(direction: direction)
    }
    exampleSubmarine.position
    exampleSubmarine.position.x * exampleSubmarine.position.y // 900 (correct)
} catch {
    print(error)
}

var challengeSubmarine = Submarine()

do {
    let puzzleDirectionArray = try puzzleArray.map { try Direction($0) }
    puzzleDirectionArray.forEach { direction in
        challengeSubmarine.apply(direction: direction)
    }
    challengeSubmarine.position
    challengeSubmarine.position.x * challengeSubmarine.position.y // 1942068080 (correct)
} catch {
    print(error)
}

