import Foundation

var greeting = "Hello, playground"

class Cave: Hashable {
    enum Schema {
        case start, large, small, end
    }
    
    enum Error: Swift.Error {
        case noStartCave
        case didntAddCaves
    }
    
    let name: String
    let schema: Schema
    var connections: Set<Cave>
    
    init(name: String) {
        self.name = name
        
        if name == "start" {
            self.schema = .start
        } else if name == "end" {
            self.schema = .end
        } else {
            if name.uppercased() == name {
                self.schema = .large
            } else {
                self.schema = .small
            }
        }
        
        self.connections = []
    }
    
    /**
     - throws: `Cave.Error.noStartCave` if there is not starting cave in the input.
     - returns: The `start` cave.
     */
    static func factory(input: String) throws -> Cave {
        var dict = [String: Cave]()
        
        let rows = input.components(separatedBy: .newlines)
        
        for row in rows {
            let caves = row.components(separatedBy: "-")
            
            let firstCaveName = caves[0]
            
            if dict[firstCaveName] == nil {
                let cave = Cave(name: firstCaveName)
                dict[firstCaveName] = cave
            }
            
            let secondCaveName = caves[1]
            
            if dict[secondCaveName] == nil {
                let cave = Cave(name: secondCaveName)
                dict[secondCaveName] = cave
            }
            
            guard let firstCave = dict[firstCaveName], let secondCave = dict[secondCaveName] else { throw Error.didntAddCaves }
            
            firstCave.add(connection: secondCave)
        }
        
        guard let start = dict["start"] else { throw Error.noStartCave }
        
        return start
    }
    
    // No inputs contain a large-large connection, an infinite loop is therefore not a concern
    func routesToEnd(existingPaths: [[Cave]] = [], depth: Int = 0) -> [[Cave]] {
        guard depth < 30 else { return [] } // (was meant to be) Protection against infinite loop
        
//        for path in existingPaths {
//            print(path, depth)
//        }
        
        switch schema {
            case .start:
                guard existingPaths.isEmpty else { return [] }
                let starterPaths = connections.flatMap { $0.routesToEnd(existingPaths: [[self]], depth: depth + 1) }
                return starterPaths
            case .end:
                guard existingPaths.isEmpty == false else { return [] }
                let finalPaths = existingPaths.map { $0 + [self] }
                for path in finalPaths {
                    print(path, depth, "(final)")
                }
                return finalPaths
            case .small:
                let validPaths = existingPaths.filter { $0.contains(where: { $0 == self } ) == false } // Path does not already contain self (a small cave).
                guard validPaths.isEmpty == false else { return [] }
                let newPaths = validPaths.map { $0 + [self] }
                let connectionsWithoutStart = connections.filter { $0.schema != .start }
                return connectionsWithoutStart.flatMap { $0.routesToEnd(existingPaths: newPaths, depth: depth + 1) }
            case .large:
                let newPaths = existingPaths.map { $0 + [self] }
                let connectionsWithoutStart = connections.filter { $0.schema != .start }
                return connectionsWithoutStart.flatMap { $0.routesToEnd(existingPaths: newPaths, depth: depth + 1) }
        }
    }
    
    func routesToEndPart2(existingPaths: [[Cave]] = [], depth: Int = 0) -> [[Cave]] {
        guard depth < 30 else { return [] } // (was meant to be) Protection against infinite loop
        
//        for path in existingPaths {
//            print(path, depth)
//        }
        
        switch schema {
            case .start:
                guard existingPaths.isEmpty else { return [] }
                let starterPaths = connections.flatMap { $0.routesToEndPart2(existingPaths: [[self]], depth: depth + 1) }
                return starterPaths
            case .end:
                guard existingPaths.isEmpty == false else { return [] }
                let finalPaths = existingPaths.map { $0 + [self] }
                for path in finalPaths {
                    print(path, depth, "(final)")
                }
                return finalPaths
            case .small:
                // Stop if the array already contains 2 of the same small cave and self
                
                let validPaths = existingPaths.filter { array in
                    for cave in array {
                        let count = array.filter { $0 == cave && $0.schema == .small }.count
                        
                        if count == 2 {
                            // If the array already contains self, we can't add it again
                            if array.contains(self) {
                                return false
                            }
                        }
                    }
                    
                    return true
                }
                
                guard validPaths.isEmpty == false else { return [] }
                let newPaths = validPaths.map { $0 + [self] }
                let connectionsWithoutStart = connections.filter { $0.schema != .start }
                return connectionsWithoutStart.flatMap { $0.routesToEndPart2(existingPaths: newPaths, depth: depth + 1) }
            case .large:
                let newPaths = existingPaths.map { $0 + [self] }
                let connectionsWithoutStart = connections.filter { $0.schema != .start }
                return connectionsWithoutStart.flatMap { $0.routesToEndPart2(existingPaths: newPaths, depth: depth + 1) }
        }
    }
    
    func add(connection: Cave) {
        self.connections.insert(connection)
        connection.connections.insert(self)
    }
    
    static func ==(lhs: Cave, rhs: Cave) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Cave: CustomStringConvertible {
    var description: String { name }
}

let exampleInput1 = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

do {
    let test = try Cave.factory(input: exampleInput1)
    test.connections
    
//    let routes = test.routesToEnd()
//    routes.count // 10 (correct)
    
    let routes2 = test.routesToEndPart2()
    routes2.count // 36 (correct)
} catch {
    error
}

let exampleInput2 = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

do {
    let test = try Cave.factory(input: exampleInput2)
//    let routes = test.routesToEnd()
//    routes.count // 19 (correct)
} catch {
    error
}

let exampleInput3 = """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

do {
    let test = try Cave.factory(input: exampleInput3)
//    let routes = test.routesToEnd()
//    routes.count // 226 (correct)
} catch {
    error
}

let puzzleInput = """
    yw-MN
    wn-XB
    DG-dc
    MN-wn
    yw-DG
    start-dc
    start-ah
    MN-start
    fi-yw
    XB-fi
    wn-ah
    MN-ah
    MN-dc
    end-yw
    fi-end
    th-fi
    end-XB
    dc-XB
    yw-XN
    wn-yw
    dc-ah
    MN-fi
    wn-DG
    """

do {
    let test = try Cave.factory(input: puzzleInput)
//    let routes = test.routesToEnd()
//    routes.count
} catch {
    error
}
