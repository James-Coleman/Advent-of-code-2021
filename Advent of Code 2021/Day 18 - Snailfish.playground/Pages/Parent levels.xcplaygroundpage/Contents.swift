import Foundation

var greeting = "Hello, playground"

enum SnailFishNumberError: Error {
    case couldntInit(from: Any)
    case splitOrExplodeWithoutIndex(split: SnailFishNumberWrapper, explode: SnailFishNumberWrapper, parent: SnailFishNumberWrapper)
}

class SnailFishNumberWrapper {
    enum SnailFishNumber {
        case parentLessPlaceholder
        case integer(Int)
        case pair(SnailFishNumberWrapper, SnailFishNumberWrapper)
        
        init(throws any: Any, parent: SnailFishNumberWrapper? = nil) throws {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                self = .pair(try SnailFishNumberWrapper(throws: array[0], parent: parent), try SnailFishNumberWrapper(throws: array[1], parent: parent))
            } else {
                throw SnailFishNumberError.couldntInit(from: any)
            }
        }
        
        init?(_ any: Any, parent: SnailFishNumberWrapper? = nil) {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                guard let left = SnailFishNumberWrapper(array[0], parent: parent), let right = SnailFishNumberWrapper(array[1], parent: parent) else { return nil }
                self = .pair(left, right)
            } else {
                return nil
            }
        }
    }
    
    let id = UUID()
    var parent: SnailFishNumberWrapper?
    var number: SnailFishNumber = .parentLessPlaceholder
    
    init(throws any: Any, parent: SnailFishNumberWrapper? = nil) throws {
        self.parent = parent
        self.number = try SnailFishNumber(throws: any, parent: self)
    }
    
    init?(_ any: Any, parent: SnailFishNumberWrapper? = nil) {
        guard let number = SnailFishNumber(any, parent: self) else { return nil }
        self.parent = parent
        self.number = number
    }
    
    init(pair: (SnailFishNumberWrapper, SnailFishNumberWrapper)) {
        self.number = .pair(pair.0, pair.1)
    }
    
    var index: Int? {
        let flattened = oldestParent.flattened
        
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return flattened.firstIndex(of: self)
            case let .pair(left, _):
                return left.index
        }
    }
    
    func shouldSplitOrExplode() -> String {
        let splitter = firstNumberThatShouldSplit
        let exploder = firstPairThatShouldExplode
        
        if let splitter = splitter, let exploder = exploder {
            if let splitterIndex = splitter.index, let exploderIndex = exploder.index {
                if splitterIndex < exploderIndex {
                    return "Should split first"
                } else {
                    return "Should explode first"
                }
            } else {
                return "Something went wrong, we have either a splitter or an exploder without an index"
            }
        }
        
        if let splitter = splitter {
            return "We should split"
        }
        
        if let exploder = exploder {
            return "We should explode"
        }
        
        return "We should no nothing"
    }
    
    /**
     - Would be nice if we could pass through the already identified splitter / exploder, otherwise they are unwrapped again in the later functions.
     - throws: `SnailFishNumberError.splitOrExplodeWithoutIndex`
     - returns: A Bool of if something was reduced (either split or exploded)
     */
    func performNextReduction() throws -> Bool {
        let splitter = firstNumberThatShouldSplit
        let exploder = firstPairThatShouldExplode
        
        if let splitter = splitter, let exploder = exploder {
            if let splitterIndex = splitter.index, let exploderIndex = exploder.index {
                if splitterIndex < exploderIndex {
                    return splitIfNecessary()
                } else {
                    return explodeIfNecessary()
                }
            } else {
                throw SnailFishNumberError.splitOrExplodeWithoutIndex(split: splitter, explode: exploder, parent: self)
            }
        }
        
        if splitter != nil {
            return splitIfNecessary()
        }
        
        if exploder != nil {
            return explodeIfNecessary()
        }
        
        return false
    }
    
    func reduce() throws {
        var didSomething = false
        
        repeat {
            didSomething = try performNextReduction()
        } while didSomething
    }
    
    var firstNumberThatShouldSplit: SnailFishNumberWrapper? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case let .integer(int):
                if int >= 10 {
                    return self
                } else {
                    return nil
                }
            case let .pair(left, right):
                if let leftRecursive = left.firstNumberThatShouldSplit {
                    return leftRecursive
                } else if let rightRecursive = right.firstNumberThatShouldSplit {
                    return rightRecursive
                } else {
                    return nil
                }
        }
    }
    
    var firstPairThatShouldExplode: SnailFishNumberWrapper? {
        guard case let .pair(outerLeft, outerRight) = number else { return nil }
        
        if
            outerLeft.parentCount >= 4,
            case let .pair(left, centre) = outerLeft.number,
            case .integer = left.number,
            case .integer = centre.number,
            case .integer = outerRight.number {
            // [[left, centre], outerRight]
            return outerLeft
        }
        
        if
            outerRight.parentCount >= 4,
            case let .pair(centre, right) = outerRight.number,
            case .integer = outerLeft.number,
            case .integer = centre.number,
            case .integer = right.number {
            // [outerLeft, [centre, right]]
            return outerRight
        }
        
        if let leftRecursive = outerLeft.firstPairThatShouldExplode {
            return leftRecursive
        }
        
        if let rightRecursive = outerRight.firstPairThatShouldExplode {
            return rightRecursive
        }
        
        return nil
    }
    
    var leftMostNumber: SnailFishNumberWrapper? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return self
            case let .pair(left, _):
                return left.leftMostNumber
        }
    }
    
    var rightMostNumber: SnailFishNumberWrapper? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return self
            case let .pair(_, right):
                return right.rightMostNumber
        }
    }
    
    var leftMostPair: SnailFishNumberWrapper? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return nil
            case let .pair(left, _):
                if case .integer = left.number {
                    return self
                } else {
                    return left.leftMostPair
                }
        }
    }
    
    var rightMostPair: SnailFishNumberWrapper? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return nil
            case let .pair(_, right):
                if case .integer = right.number {
                    return self
                } else {
                    return right.rightMostPair
                }
        }
    }
    
    var leftNeighbour: SnailFishNumberWrapper? {
        neighbourToLeft(of: self)
    }
    
    var rightNeighbour: SnailFishNumberWrapper? {
        neighbourToRight(of: self)
    }
    
    func neighbourToRight(of number: SnailFishNumberWrapper) -> SnailFishNumberWrapper? {
        if rightMostPair == number {
            return parent?.neighbourToRight(of: number)
        } else {
            switch self.number {
                case .parentLessPlaceholder:
                    return nil
                case .integer: // Don't know if this will ever be used
                    return self
                case let .pair(_, right):
                    return right.leftMostNumber
            }
        }
    }
    
    func neighbourToLeft(of number: SnailFishNumberWrapper) -> SnailFishNumberWrapper? {
        if leftMostPair == number {
            return parent?.neighbourToLeft(of: number)
        } else {
            switch self.number {
                case .parentLessPlaceholder:
                    return nil
                case .integer: // Don't know if this will ever be used
                    return self
                case let .pair(left, _):
                    return left.rightMostNumber
            }
        }
    }
    
    /// AKA rootNode
    var oldestParent: SnailFishNumberWrapper {
        if let parent = parent {
            return parent.oldestParent
        } else {
            return self
        }
    }
    
    var parentCount: Int {
        if let parent = parent {
            return parent.parentCount + 1
        } else {
            return 0
        }
        
//        (parent?.parentCount ?? -1) + 1 // cheesy but it would work
    }
    
    var flattened: [SnailFishNumberWrapper] {
        switch number {
            case .parentLessPlaceholder:
                return []
            case .integer:
                return [self]
            case let .pair(left, right):
                return [left.flattened, right.flattened].flatMap { $0 }
        }
    }
    
    var flattenedPairs: [SnailFishNumberWrapper] {
        switch number {
            case .parentLessPlaceholder:
                return []
            case .integer:
                return []
            case let .pair(left, right):
                if case .integer = left.number, case .integer = right.number {
                    return [self]
                } else if case .integer = left.number {
                    return [left] + right.flattenedPairs
                } else if case .integer = right.number {
                    return left.flattenedPairs + [right]
                } else {
                    return left.flattenedPairs + right.flattenedPairs
                }
        }
    }
    
    /**
     I'm not convinced this is incrementing the levels properly.
     We might need to use a parent based level system.
     */
    static func + (lhs: SnailFishNumberWrapper, rhs: SnailFishNumberWrapper) -> SnailFishNumberWrapper {
        let newPair = SnailFishNumberWrapper(pair: (lhs, rhs))
        
        lhs.parent = newPair
        rhs.parent = newPair
        
        return newPair
    }
    
    /**
     - returns: Bool of if something was split
     */
    func splitIfNecessary() -> Bool {
        if let split = firstNumberThatShouldSplit, case let .integer(int) = split.number {
            let (quotient, remainder) = int.quotientAndRemainder(dividingBy: 2)
            
            guard let left = SnailFishNumberWrapper(quotient, parent: split), let right = SnailFishNumberWrapper(quotient + remainder, parent: split) else { return false }
            
            split.number = .pair(left, right)
            
            return true
        } else {
            return false
        }
    }
    
    func explodeIfNecessary() -> Bool {
        if let exploding = firstPairThatShouldExplode, case let .pair(left, right) = exploding.number, case let .integer(leftInt) = left.number, case let .integer(rightInt) = right.number {
            // The left number of the pair should be added to the left neighbour
            if let leftNeighbour = exploding.leftNeighbour, case let .integer(leftNeighbourInt) = leftNeighbour.number {
                leftNeighbour.number = .integer(leftNeighbourInt + leftInt)
            }
            
            // The right number of the pair should be added to the right neighbour
            if let rightNeighbour = exploding.rightNeighbour, case let .integer(rightNeighbourInt) = rightNeighbour.number {
                rightNeighbour.number = .integer(rightNeighbourInt + rightInt)
            }
            
            // The pair itself should always reset to 0
            exploding.number = .integer(0)
            
            return true
        } else {
            return false
        }
    }
}

extension SnailFishNumberWrapper: Equatable {
    static func == (lhs: SnailFishNumberWrapper, rhs: SnailFishNumberWrapper) -> Bool {
        lhs.id == rhs.id
    }
}

extension SnailFishNumberWrapper: CustomStringConvertible {
    var description: String {
        switch number {
            case .parentLessPlaceholder:
                return "PARENTLESS PLACEHOLDER SHOULD NOT BE HERE"
            case let .integer(int):
                return "\(int)"
            case let .pair(left, right):
                return "[\(left),\(right)]"
        }
    }
}

let example1 = SnailFishNumberWrapper([1,2])
let example2 = SnailFishNumberWrapper([[1,2],3])
let example3 = SnailFishNumberWrapper([9,[8,7]])
let example4 = SnailFishNumberWrapper([[1,9], [8,5]])
example4?.flattenedPairs
let example5 = SnailFishNumberWrapper([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
let example6 = SnailFishNumberWrapper([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
let example7 = SnailFishNumberWrapper([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])

let exampleAdded = SnailFishNumberWrapper([1,2])! + SnailFishNumberWrapper([[3,4],5])!

//exampleAdded.flattenedPairs.forEach { print($0, $0.parentCount) }

let splitExample0 = SnailFishNumberWrapper(9)!
let splitExample1 = SnailFishNumberWrapper(10)!
let splitExample2 = SnailFishNumberWrapper(11)!
let splitExample3 = SnailFishNumberWrapper(12)!
splitExample0.shouldSplitOrExplode()
splitExample1.shouldSplitOrExplode()
splitExample2.shouldSplitOrExplode()
splitExample3.shouldSplitOrExplode()
splitExample0.firstNumberThatShouldSplit
splitExample1.firstNumberThatShouldSplit
splitExample2.firstNumberThatShouldSplit
splitExample3.firstNumberThatShouldSplit
splitExample0.splitIfNecessary()
splitExample1.splitIfNecessary()
splitExample2.splitIfNecessary()
splitExample3.splitIfNecessary()
splitExample0
splitExample1
splitExample2
splitExample3

let explodeExample1 = SnailFishNumberWrapper([[[[[9,8],1],2],3],4])!
explodeExample1.shouldSplitOrExplode()
explodeExample1.explodeIfNecessary()
explodeExample1
explodeExample1.shouldSplitOrExplode()

let explodeExample2 = SnailFishNumberWrapper([7,[6,[5,[4,[3,2]]]]])!
explodeExample2.shouldSplitOrExplode()
explodeExample2.explodeIfNecessary()
explodeExample2

let explodeExample3 = SnailFishNumberWrapper([[6,[5,[4,[3,2]]]],1])!
explodeExample3.shouldSplitOrExplode()
explodeExample3.explodeIfNecessary()
explodeExample3

let explodeExample4 = SnailFishNumberWrapper([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])!
explodeExample4.shouldSplitOrExplode()
explodeExample4.explodeIfNecessary()
explodeExample4

let explodeExample5 = SnailFishNumberWrapper([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])!
explodeExample5.shouldSplitOrExplode()
explodeExample5.explodeIfNecessary()
explodeExample5

let steppedExample1 = SnailFishNumberWrapper([[[[4,3],4],4],[7,[[8,4],9]]])! + SnailFishNumberWrapper([1,1])!
steppedExample1.shouldSplitOrExplode()
steppedExample1.explodeIfNecessary()
steppedExample1
steppedExample1.shouldSplitOrExplode()
steppedExample1.explodeIfNecessary()
steppedExample1
steppedExample1.shouldSplitOrExplode()
steppedExample1.splitIfNecessary()
steppedExample1
steppedExample1.shouldSplitOrExplode()
steppedExample1.splitIfNecessary()
steppedExample1
steppedExample1.shouldSplitOrExplode()
steppedExample1.explodeIfNecessary()
steppedExample1
steppedExample1.shouldSplitOrExplode()

do {
    let steppedExample2 = SnailFishNumberWrapper([[[[4,3],4],4],[7,[[8,4],9]]])! + SnailFishNumberWrapper([1,1])!
    try steppedExample2.reduce()
    steppedExample2
    
    let steppedExample3 = SnailFishNumberWrapper([1,1])! + SnailFishNumberWrapper([2,2])! + SnailFishNumberWrapper([3,3])! + SnailFishNumberWrapper([4,4])!
    try steppedExample3.reduce()
    steppedExample3
    
    let steppedExample4 = SnailFishNumberWrapper([1,1])! + SnailFishNumberWrapper([2,2])! + SnailFishNumberWrapper([3,3])! + SnailFishNumberWrapper([4,4])! + SnailFishNumberWrapper([5,5])!
    try steppedExample4.reduce()
    steppedExample4
    
    let steppedExample5 = SnailFishNumberWrapper([1,1])! + SnailFishNumberWrapper([2,2])! + SnailFishNumberWrapper([3,3])! + SnailFishNumberWrapper([4,4])! + SnailFishNumberWrapper([5,5])! + SnailFishNumberWrapper([6,6])!
    try steppedExample5.reduce()
    steppedExample5
} catch {
    error
}
