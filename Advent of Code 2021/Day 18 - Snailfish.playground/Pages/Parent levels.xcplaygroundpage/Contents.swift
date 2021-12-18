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
    static func splitIfNecessary(_ number: SnailFishNumberWrapper) -> Bool {
        let flattened = number.flattened
        
        for wrapper in flattened {
            guard case let .integer(int) = wrapper.number else { continue }
            
            if int >= 10 {
                let (quotient, remainder) = int.quotientAndRemainder(dividingBy: 2)
                
                guard let left = SnailFishNumberWrapper(quotient, parent: wrapper), let right = SnailFishNumberWrapper(quotient + remainder, parent: wrapper) else { continue }
                
                wrapper.number = .pair(left, right)
                
                return true
            }
        }
        
        return false
    }
    
    /**
     - returns: Bool of if something was exploded
     */
    static func explodeIfNecessary(_ number: SnailFishNumberWrapper) -> Bool {
        let flattenedPairs = number.flattenedPairs

        for (index, wrapper) in flattenedPairs.enumerated() {
            if wrapper.parentCount >= 4, case let .pair(left, right) = wrapper.number, case let .integer(leftInt) = left.number, case let .integer(rightInt) = right.number {
                
                if index == 0 {
                    
                } else {
                    
                }

                return true
            }
        }

        return false
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
example4?.flattened
example4?.flattenedPairs
let example5 = SnailFishNumberWrapper([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
let example6 = SnailFishNumberWrapper([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
let example7 = SnailFishNumberWrapper([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])

let exampleAdded = SnailFishNumberWrapper([1,2])! + SnailFishNumberWrapper([[3,4],5])!

exampleAdded.flattened.forEach { print($0, $0.parentCount) }
exampleAdded.flattenedPairs.forEach { print($0, $0.parentCount) }

let splitExample0 = SnailFishNumberWrapper(9)!
let splitExample1 = SnailFishNumberWrapper(10)!
let splitExample2 = SnailFishNumberWrapper(11)!
let splitExample3 = SnailFishNumberWrapper(12)!
SnailFishNumberWrapper.splitIfNecessary(splitExample0)
SnailFishNumberWrapper.splitIfNecessary(splitExample1)
SnailFishNumberWrapper.splitIfNecessary(splitExample2)
SnailFishNumberWrapper.splitIfNecessary(splitExample3)
splitExample0
splitExample1
splitExample2
splitExample3

let explodeExample = SnailFishNumberWrapper([[[[[9,8],1],2],3],4])
explodeExample?.flattened.forEach { print($0, $0.parentCount) }
explodeExample?.flattenedPairs.forEach { print($0, $0.parentCount) }
