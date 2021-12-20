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

let testString = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##"

testString[String.Index(utf16Offset: 0, in: testString)]
testString[String.Index(utf16Offset: 1, in: testString)]
testString[String.Index(utf16Offset: 2, in: testString)]
testString[String.Index(utf16Offset: 3, in: testString)]
testString[String.Index(utf16Offset: 4, in: testString)]
testString[String.Index(utf16Offset: 5, in: testString)]
testString[String.Index(utf16Offset: 10, in: testString)]
testString[String.Index(utf16Offset: 20, in: testString)]
testString[String.Index(utf16Offset: 30, in: testString)]
testString[String.Index(utf16Offset: 34, in: testString)]
testString[String.Index(utf16Offset: 40, in: testString)]
testString[String.Index(utf16Offset: 50, in: testString)]
testString[String.Index(utf16Offset: 60, in: testString)]
testString[String.Index(utf16Offset: 70, in: testString)]

let exampleInput = """
#..#.
#....
##..#
..#..
..###
"""

let exampleAlgorithm = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#
"""

enum Error: Swift.Error {
    case couldNotCreateInt(from: String)
}

func nextImage(from input: String, algorithm: String, currentGeneration: Int = 0) throws -> [[Character]] {
    
    let mapped = input.components(separatedBy: .newlines).map { $0.map { $0 == "." ? "0" : "1" } }
    
    guard let firstRow = mapped.first else { return [] }
    
    var arrayToReturn = [[Character]]()
    
    /// Will either be `0` if outside margins can be assumed to be `.` or `1` if outside margins can be assumed to be `#`
    let assumptionCharacter: String = {
        if currentGeneration % 2 == 0 {
            return "0"
        } else {
            if algorithm.first == "." {
                return "0"
            } else {
                return "1"
            }
        }
    }()
    
    for rowIndex in -1...mapped.count {
        var characterArray = [Character]()
        
        for columnIndex in -1...firstRow.count {
            let topLeft = mapped[safe: rowIndex - 1]?[safe: columnIndex - 1] ?? assumptionCharacter
            let topMiddle = mapped[safe: rowIndex - 1]?[safe: columnIndex] ?? assumptionCharacter
            let topRight = mapped[safe: rowIndex - 1]?[safe: columnIndex + 1] ?? assumptionCharacter
            let centreLeft = mapped[safe: rowIndex]?[safe: columnIndex - 1] ?? assumptionCharacter
            let centreMiddle = mapped[safe: rowIndex]?[safe: columnIndex] ?? assumptionCharacter
            let centreRight = mapped[safe: rowIndex]?[safe: columnIndex + 1] ?? assumptionCharacter
            let bottomLeft = mapped[safe: rowIndex + 1]?[safe: columnIndex - 1] ?? assumptionCharacter
            let bottomMiddle = mapped[safe: rowIndex + 1]?[safe: columnIndex] ?? assumptionCharacter
            let bottomRight = mapped[safe: rowIndex + 1]?[safe: columnIndex + 1] ?? assumptionCharacter
            
            let binaryNumber = "\(topLeft)\(topMiddle)\(topRight)\(centreLeft)\(centreMiddle)\(centreRight)\(bottomLeft)\(bottomMiddle)\(bottomRight)"
            
            guard let int = Int(binaryNumber, radix: 2) else { throw Error.couldNotCreateInt(from: binaryNumber) }
            
            let newPixel = algorithm[String.Index(utf16Offset: int, in: algorithm)]
            
            characterArray += [newPixel]
        }
        
        arrayToReturn += [characterArray]
    }
    
    return arrayToReturn
}

func nextImage(from input: [[Character]], algorithm: String, currentGeneration: Int = 0) throws -> [[Character]] {
    let mapped = input.map { $0.map { $0 == "." ? "0" : "1" } }
    
    guard let firstRow = mapped.first else { return [] }
    
    var arrayToReturn = [[Character]]()
    
    /// Will either be `0` if outside margins can be assumed to be `.` or `1` if outside margins can be assumed to be `#`
    let assumptionCharacter: String = {
        if currentGeneration % 2 == 0 {
            return "0"
        } else {
            if algorithm.first == "." {
                return "0"
            } else {
                return "1"
            }
        }
    }()
    
    for rowIndex in -1...mapped.count {
        var characterArray = [Character]()
        
        for columnIndex in -1...firstRow.count {
            let topLeft = mapped[safe: rowIndex - 1]?[safe: columnIndex - 1] ?? assumptionCharacter
            let topMiddle = mapped[safe: rowIndex - 1]?[safe: columnIndex] ?? assumptionCharacter
            let topRight = mapped[safe: rowIndex - 1]?[safe: columnIndex + 1] ?? assumptionCharacter
            let centreLeft = mapped[safe: rowIndex]?[safe: columnIndex - 1] ?? assumptionCharacter
            let centreMiddle = mapped[safe: rowIndex]?[safe: columnIndex] ?? assumptionCharacter
            let centreRight = mapped[safe: rowIndex]?[safe: columnIndex + 1] ?? assumptionCharacter
            let bottomLeft = mapped[safe: rowIndex + 1]?[safe: columnIndex - 1] ?? assumptionCharacter
            let bottomMiddle = mapped[safe: rowIndex + 1]?[safe: columnIndex] ?? assumptionCharacter
            let bottomRight = mapped[safe: rowIndex + 1]?[safe: columnIndex + 1] ?? assumptionCharacter
            
            let binaryNumber = "\(topLeft)\(topMiddle)\(topRight)\(centreLeft)\(centreMiddle)\(centreRight)\(bottomLeft)\(bottomMiddle)\(bottomRight)"
            
            guard let int = Int(binaryNumber, radix: 2) else { throw Error.couldNotCreateInt(from: binaryNumber) }
            
            let newPixel = algorithm[String.Index(utf16Offset: int, in: algorithm)]
            
            characterArray += [newPixel]
        }
        
        arrayToReturn += [characterArray]
    }
    
    return arrayToReturn
}

func litPixels(in input: [[Character]]) -> Int {
    input.reduce(0) { partialResult, row in
        partialResult + row.filter { $0 == "#" }.count
    }
}

func reduced(image: [[Character]]) -> String {
    image.reduce("") { soFar, next in
        soFar + next.reduce("") { soFar, next in
            "\(soFar)\(next)"
        } + "\n"
    }
}

func generation(_ generation: Int, of input: String, using algorithm: String) throws -> [[Character]] {
    var currentIteration: [[Character]]? = nil
    
    for i in 0..<generation {
        if let currentIterationUnwrapped = currentIteration {
            currentIteration = try nextImage(from: currentIterationUnwrapped, algorithm: algorithm, currentGeneration: i)
        } else {
            currentIteration = try nextImage(from: input, algorithm: algorithm, currentGeneration: i)
        }
    }
    
    return currentIteration ?? []
}

do {
    let exampleGen1 = try nextImage(from: exampleInput, algorithm: exampleAlgorithm)
    let exampleGen1Reduced = reduced(image: exampleGen1)
    print(exampleGen1Reduced)
    
    print("---")
    
    let exampleGen2 = try nextImage(from: exampleGen1, algorithm: exampleAlgorithm)
    let exampleGen2Reduced = reduced(image: exampleGen2)
    print(exampleGen2Reduced)
    litPixels(in: exampleGen2)
    
    let exampleGen50 = try generation(50, of: exampleInput, using: exampleAlgorithm)
    litPixels(in: exampleGen50)
} catch {
    error
}
