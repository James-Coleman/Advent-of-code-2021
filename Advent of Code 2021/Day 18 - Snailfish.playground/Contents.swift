import Foundation

var greeting = "Hello, playground"

indirect enum SnailFishNumber {
    enum Error: Swift.Error {
        case couldntInit(from: Any)
    }
    
    case integer(Int)
    case pair(SnailFishNumber, SnailFishNumber)
    
    init(_ any: Any) throws {
        if let int = any as? Int {
            self = .integer(int)
        } else if let array = any as? [Any] {
            self = .pair(try SnailFishNumber(array[0]), try SnailFishNumber(array[1]))
        } else {
            throw Error.couldntInit(from: any)
        }
    }
}

extension SnailFishNumber: CustomStringConvertible {
    var description: String {
        switch self {
            case let .integer(int):
                return "\(int)"
            case let .pair(left, right):
                return "[\(left),\(right)]"
        }
    }
}

// This is now only being used for example3
extension SnailFishNumber: ExpressibleByIntegerLiteral {
    init(integerLiteral value: IntegerLiteralType) {
        self = .integer(value)
    }
}

//extension SnailFishNumber: ExpressibleByArrayLiteral {
//    typealias ArrayLiteralElement = Any
//
//    init(arrayLiteral elements: ArrayLiteralElement...) {
////        if let firstNumber = elements[0] as? Int, let secondNumber = elements[1] as? Int {
////            self = .pair(.integer(firstNumber), .integer(secondNumber))
////        } else if let firstNumber = elements[0] as? Int, let right = elements[1] as? [Any] {
////            self = .pair(.integer(firstNumber), try SnailFishNumber(elements[1]))// .pair(SnailFishNumber(right[0]), SnailFishNumber(right[1])))
////        } else if let secondNumber = elements[1] as? Int {
////            self = .pair(try SnailFishNumber(elements[0]), .integer(secondNumber))
////        }
//
//        if let elements = elements as? [Int] {
//            self = .pair(.integer(elements[0]), .integer(elements[1]))
//        } else {
//            self = SnailFishNumber(elements)
//        }
//    }
//}

let example1 = SnailFishNumber.pair(.integer(1), .integer(2))
let example2 = SnailFishNumber.pair(.pair(.integer(1), .integer(2)), .integer(3))
let example3 = SnailFishNumber.pair(9, .pair(8, 7))

do {
    let example4 = try SnailFishNumber([[1,9], [8,5]])
    let example5 = try SnailFishNumber([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
    let example6 = try SnailFishNumber([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
    let example7 = try SnailFishNumber([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])
} catch {
    error
}
