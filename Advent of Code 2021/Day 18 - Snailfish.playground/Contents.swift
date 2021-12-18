import Foundation

var greeting = "Hello, playground"

enum SnailFishNumberError: Error {
    case couldntInit(from: Any)
}

class SnailFishNumberWrapper {
    enum SnailFishNumber {
        case integer(Int)
        case pair(SnailFishNumberWrapper, SnailFishNumberWrapper)
        
        init(throws any: Any) throws {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                self = .pair(try SnailFishNumberWrapper(throws: array[0]), try SnailFishNumberWrapper(throws: array[1]))
            } else {
                throw SnailFishNumberError.couldntInit(from: any)
            }
        }
        
        init?(_ any: Any) {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                guard let left = SnailFishNumberWrapper(array[0]), let right = SnailFishNumberWrapper(array[1]) else { return nil }
                self = .pair(left, right)
            } else {
                return nil
            }
        }
    }
    
    var number: SnailFishNumber
    
    init(throws any: Any) throws {
        self.number = try SnailFishNumber(throws: any)
    }
    
    init?(_ any: Any) {
        guard let number = SnailFishNumber(any) else { return nil }
        self.number = number
    }
    
    init(pair: (SnailFishNumberWrapper, SnailFishNumberWrapper)) {
        self.number = .pair(pair.0, pair.1)
    }
    
    var flattened: [SnailFishNumberWrapper] {
        switch number {
            case .integer:
                return [self]
            case let .pair(left, right):
                return [left.flattened, right.flattened].flatMap { $0 }
        }
    }
    
    func flattened(level: Int = 0) -> [(level: Int, snailFishNumber: SnailFishNumberWrapper)] {
        switch number {
            case .integer:
                return [(level, self)]
            case let .pair(left, right):
                return [left.flattened(level: level + 1), right.flattened(level: level + 1)].flatMap { $0 }
        }
    }
    
    static func + (lhs: SnailFishNumberWrapper, rhs: SnailFishNumberWrapper) -> SnailFishNumberWrapper {
        SnailFishNumberWrapper(pair: (lhs, rhs))
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
                
                guard let left = SnailFishNumberWrapper(quotient), let right = SnailFishNumberWrapper(quotient + remainder) else { continue }
                
                wrapper.number = .pair(left, right)
                
                return true
            }
        }
        
        return false
    }
    
    /**
     - returns: Bool of if something was split
     */
    static func explodeIfNecessary(_ number: SnailFishNumberWrapper) -> Bool {
        let flattened = number.flattened()
        
        for (index, wrapper) in flattened.enumerated() {
            if wrapper.level >= 4 {
                
                
                return true
            }
        }
        
        return false
    }
}

extension SnailFishNumberWrapper: CustomStringConvertible {
    var description: String {
        switch number {
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
example4?.flattened()
let example5 = SnailFishNumberWrapper([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
let example6 = SnailFishNumberWrapper([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
let example7 = SnailFishNumberWrapper([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])

SnailFishNumberWrapper([1,2])! + SnailFishNumberWrapper([[3,4],5])!

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

