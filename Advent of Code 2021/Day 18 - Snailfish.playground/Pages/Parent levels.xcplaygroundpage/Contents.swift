import Foundation

var greeting = "Hello, playground"

enum SnailFishNumberError: Error {
    case couldntInit(from: Any)
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
        
//        print(self)
        
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
    
    var parentCount: Int {
        if let parent = parent {
            return parent.parentCount + 1
        } else {
            return 0
        }
        
//        (parent?.parentCount ?? -1) + 1 // cheesy but it would work
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
    
    /**
     This isn't working because the flattenedPairs variable unwraps the Numbers too far
     - returns: Bool of if something was exploded
     */
    static func explodeIfNecessary(_ number: SnailFishNumberWrapper) -> Bool {
        let flattenedPairs = number.flattenedPairs

        for (index, wrapper) in flattenedPairs.enumerated() {
            print(wrapper, wrapper.parentCount)
            
            if
                case let .pair(leftNumber, rightNumber) = wrapper.number,
                leftNumber.parentCount >= 4,
                case let .pair(left, center) = leftNumber.number,
                case let .integer(leftInt) = left.number,
                case let .integer(centreInt) = center.number,
                case let .integer(rightInt) = rightNumber.number {
                // [[left, centre], right]
                let sum = centreInt + rightInt
                
                guard
                    let newLeft = SnailFishNumberWrapper(0, parent: wrapper),
                    let newRight = SnailFishNumberWrapper(sum, parent: wrapper)
                else { continue }
                
                wrapper.number = .pair(newLeft, newRight)
                
                // add leftInt to index - 1
                
                if index > 0, case let .integer(previousInt) = flattenedPairs[index - 1].number {
                    let otherSum = previousInt + leftInt
                    
                    flattenedPairs[index - 1].number = .integer(otherSum)
                }
                
                return true
            }
            
            if
                case let .pair(leftNumber, rightNumber) = wrapper.number,
                rightNumber.parentCount >= 4,
                case let .pair(center, right) = rightNumber.number,
                case let .integer(leftInt) = leftNumber.number,
                case let .integer(centreInt) = center.number,
                case let .integer(rightInt) = right.number {
                // [left, [centre, right]]
                let sum = leftInt + centreInt
                
                guard
                    let newLeft = SnailFishNumberWrapper(sum, parent: wrapper),
                    let newRight = SnailFishNumberWrapper(0, parent: wrapper)
                else { continue }
                
                wrapper.number = .pair(newLeft, newRight)
                
                // add rightInt to index + 1
                
                if index < flattenedPairs.count - 1, case let .integer(nextInt) = flattenedPairs[index + 1].number {
                    let otherSum = rightInt + nextInt
                    
                    flattenedPairs[index + 1].number = .integer(otherSum)
                }
                
                return true
            }
        }

        return false
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
//explodeExample1.flattenedPairs.forEach { print($0, $0.parentCount) }
explodeExample1.firstPairThatShouldExplode
//SnailFishNumberWrapper.explodeIfNecessary(explodeExample1)
explodeExample1
explodeExample1.firstPairThatShouldExplode?.rightNeighbour

let explodeExample2 = SnailFishNumberWrapper([7,[6,[5,[4,[3,2]]]]])!
explodeExample2.firstPairThatShouldExplode
explodeExample2.firstPairThatShouldExplode?.leftNeighbour

let explodeExample3 = SnailFishNumberWrapper([[6,[5,[4,[3,2]]]],1])!
explodeExample3.firstPairThatShouldExplode
explodeExample3.firstPairThatShouldExplode?.rightNeighbour

let explodeExample4 = SnailFishNumberWrapper([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])!
explodeExample4.firstPairThatShouldExplode
explodeExample4.firstPairThatShouldExplode?.rightNeighbour

let explodeExample5 = SnailFishNumberWrapper([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])!
explodeExample5.firstPairThatShouldExplode
explodeExample5.firstPairThatShouldExplode?.rightNeighbour
