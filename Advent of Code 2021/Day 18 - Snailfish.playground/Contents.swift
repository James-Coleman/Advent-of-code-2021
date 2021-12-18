import Foundation

var greeting = "Hello, playground"

enum SnailFishNumberError: Error {
    case couldntInit(from: Any)
}

class SnailFishNumberWrapper {
    enum SnailFishNumber {
        case integer(Int)
        case pair(SnailFishNumberWrapper, SnailFishNumberWrapper)
        
        init(_ any: Any) throws {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                self = .pair(try SnailFishNumberWrapper(array[0]), try SnailFishNumberWrapper(array[1]))
            } else {
                throw SnailFishNumberError.couldntInit(from: any)
            }
        }
    }
    
    let number: SnailFishNumber
    
    init(_ any: Any) throws {
        self.number = try SnailFishNumber(any)
    }
    
    var flattened: [SnailFishNumberWrapper] {
        switch number {
            case .integer:
                return [self]
            case let .pair(left, right):
                return [left.flattened, right.flattened].flatMap { $0 }
        }
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

do {
    let example1 = try SnailFishNumberWrapper([1,2])
    let example2 = try SnailFishNumberWrapper([[1,2],3])
    let example3 = try SnailFishNumberWrapper([9,[8,7]])
    let example4 = try SnailFishNumberWrapper([[1,9], [8,5]])
    example4.flattened
    let example5 = try SnailFishNumberWrapper([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
    let example6 = try SnailFishNumberWrapper([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
    let example7 = try SnailFishNumberWrapper([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])
} catch {
    
}
