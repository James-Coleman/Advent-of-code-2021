import Foundation

var greeting = "Hello, playground"

class SnailFishNumber {
    enum Error: Swift.Error {
        case couldntInit(from: Any)
    }
    
    enum Number {
        case parentLessPlaceholder
        case integer(Int)
        case pair(SnailFishNumber, SnailFishNumber)
        
        init(throws any: Any, parent: SnailFishNumber? = nil) throws {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                self = .pair(try SnailFishNumber(throws: array[0], parent: parent), try SnailFishNumber(throws: array[1], parent: parent))
            } else {
                throw Error.couldntInit(from: any)
            }
        }
        
        init?(_ any: Any, parent: SnailFishNumber? = nil) {
            if let int = any as? Int {
                self = .integer(int)
            } else if let array = any as? [Any] {
                guard let left = SnailFishNumber(array[0], parent: parent), let right = SnailFishNumber(array[1], parent: parent) else { return nil }
                self = .pair(left, right)
            } else {
                return nil
            }
        }
    }
    
    let id = UUID()
    var parent: SnailFishNumber?
    var number: Number = .parentLessPlaceholder
    
    init(throws any: Any, parent: SnailFishNumber? = nil) throws {
        self.parent = parent
        self.number = try Number(throws: any, parent: self)
    }
    
    init?(_ any: Any, parent: SnailFishNumber? = nil) {
        guard let number = Number(any, parent: self) else { return nil }
        self.parent = parent
        self.number = number
    }
    
    init(pair: (SnailFishNumber, SnailFishNumber)) {
        self.number = .pair(pair.0, pair.1)
        pair.0.parent = self
        pair.1.parent = self
    }
    
    var magnitude: Int {
        switch number {
            case .parentLessPlaceholder:
                return 0
            case let .pair(left, right):
                return (3 * left.magnitude) + (2 * right.magnitude)
            case let .integer(int):
                return int
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
    
    var firstNumberThatShouldSplit: SnailFishNumber? {
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
    
    var firstPairThatShouldExplode: SnailFishNumber? {
        guard case let .pair(left, right) = number else { return nil }
        
        if
            parentCount >= 4,
            case .integer = left.number,
            case .integer = right.number {
            return self
        }
        
        if let leftRecursive = left.firstPairThatShouldExplode {
            return leftRecursive
        }
        
        if let rightRecursive = right.firstPairThatShouldExplode {
            return rightRecursive
        }
        
        return nil
    }
    
    var leftMostNumber: SnailFishNumber? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return self
            case let .pair(left, _):
                return left.leftMostNumber
        }
    }
    
    var rightMostNumber: SnailFishNumber? {
        switch number {
            case .parentLessPlaceholder:
                return nil
            case .integer:
                return self
            case let .pair(_, right):
                return right.rightMostNumber
        }
    }
    
    var leftMostPair: SnailFishNumber? {
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
    
    var rightMostPair: SnailFishNumber? {
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
    
    var leftNeighbour: SnailFishNumber? {
        neighbourToLeft(of: self)
    }
    
    var rightNeighbour: SnailFishNumber? {
        neighbourToRight(of: self)
    }
    
    func neighbourToRight(of number: SnailFishNumber) -> SnailFishNumber? {
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
    
    func neighbourToLeft(of number: SnailFishNumber) -> SnailFishNumber? {
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
    
    /**
     - returns: A Bool of if something was reduced (either split or exploded)
     */
    func performNextReduction() -> Bool {
//        print(self)
        
        if let firstPairThatShouldExplode = firstPairThatShouldExplode {
            return SnailFishNumber.explode(firstPairThatShouldExplode)
        }
        
        if let firstNumberThatShouldSplit = firstNumberThatShouldSplit {
            return SnailFishNumber.split(firstNumberThatShouldSplit)
        }
        
        return false
    }
    
    func reduce() {
        var didSomething: Bool
        
        repeat {
            didSomething = performNextReduction()
        } while didSomething
    }
}

extension SnailFishNumber {
    static func explode(_ number: SnailFishNumber) -> Bool {
        guard
            case let .pair(left, right) = number.number,
            case let .integer(leftInt) = left.number,
            case let .integer(rightInt) = right.number
        else { return false }
        
        // The left number of the pair should be added to the left neighbour
        if let leftNeighbour = number.leftNeighbour, case let .integer(leftNeighbourInt) = leftNeighbour.number {
            leftNeighbour.number = .integer(leftNeighbourInt + leftInt)
        }
        
        // The right number of the pair should be added to the right neighbour
        if let rightNeighbour = number.rightNeighbour, case let .integer(rightNeighbourInt) = rightNeighbour.number {
            rightNeighbour.number = .integer(rightNeighbourInt + rightInt)
        }
        
        // The pair itself should always reset to 0
        number.number = .integer(0)
        
        return true
    }
    
    static func split(_ number: SnailFishNumber) -> Bool {
        guard case let .integer(int) = number.number else { return false }
        
        let (quotient, remainder) = int.quotientAndRemainder(dividingBy: 2)
        
        guard
            let left = SnailFishNumber(quotient, parent: number),
            let right = SnailFishNumber(quotient + remainder, parent: number)
        else { return false }
        
        number.number = .pair(left, right)
        
        return true
    }
    
    static func + (lhs: SnailFishNumber, rhs: SnailFishNumber) -> SnailFishNumber {
        let newPair = SnailFishNumber(pair: (lhs, rhs))
        
        newPair.reduce()
        
        return newPair
    }
}

extension SnailFishNumber: Equatable {
    static func == (lhs: SnailFishNumber, rhs: SnailFishNumber) -> Bool {
        lhs.id == rhs.id
    }
}

extension SnailFishNumber: CustomStringConvertible {
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

/*
let example1 = SnailFishNumber([1,2])
let example2 = SnailFishNumber([[1,2],3])
let example3 = SnailFishNumber([9,[8,7]])
let example4 = SnailFishNumber([[1,9], [8,5]])
let example5 = SnailFishNumber([[[[1,2],[3,4]],[[5,6],[7,8]]],9])
let example6 = SnailFishNumber([[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]])
let example7 = SnailFishNumber([[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]])

let exampleAdded = SnailFishNumber([1,2])! + SnailFishNumber([[3,4],5])!

let splitExample0 = SnailFishNumber(9)!
let splitExample1 = SnailFishNumber(10)!
let splitExample2 = SnailFishNumber(11)!
let splitExample3 = SnailFishNumber(12)!
splitExample0.firstNumberThatShouldSplit
splitExample1.firstNumberThatShouldSplit
splitExample2.firstNumberThatShouldSplit
splitExample3.firstNumberThatShouldSplit
splitExample0.reduce()
splitExample1.reduce()
splitExample2.reduce()
splitExample3.reduce()

let explodeExample1 = SnailFishNumber([[[[[9,8],1],2],3],4])!
explodeExample1.reduce()

let explodeExample2 = SnailFishNumber([7,[6,[5,[4,[3,2]]]]])!
explodeExample2.reduce()

let explodeExample3 = SnailFishNumber([[6,[5,[4,[3,2]]]],1])!
explodeExample3.reduce()

let explodeExample4 = SnailFishNumber([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])!
explodeExample4.reduce()

let explodeExample5 = SnailFishNumber([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])!
explodeExample5.reduce()

let steppedExample1 = SnailFishNumber([[[[4,3],4],4],[7,[[8,4],9]]])! + SnailFishNumber([1,1])!

let reducedExample1 = SnailFishNumber([1,1])! + SnailFishNumber([2,2])! + SnailFishNumber([3,3])! + SnailFishNumber([4,4])!

let reducedExample2 = SnailFishNumber([1,1])! + SnailFishNumber([2,2])! + SnailFishNumber([3,3])! + SnailFishNumber([4,4])! + SnailFishNumber([5,5])!

let reducedExample2a = SnailFishNumber([[[[[1,1],[2,2]],[3,3]],[4,4]],[5,5]])!
reducedExample2a.reduce()

let reducedExample3 = SnailFishNumber([1,1])! + SnailFishNumber([2,2])! + SnailFishNumber([3,3])! + SnailFishNumber([4,4])! + SnailFishNumber([5,5])! + SnailFishNumber([6,6])!

// [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] (correct) (finally)
let reducedExample4 = SnailFishNumber([[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]])!
+ SnailFishNumber([7,[[[3,7],[4,3]],[[6,3],[8,8]]]])!
+ SnailFishNumber([[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]])!
+ SnailFishNumber([[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]])!
+ SnailFishNumber([7,[5,[[3,8],[1,4]]]])!
+ SnailFishNumber([[2,[2,2]],[8,[8,1]]])!
+ SnailFishNumber([2,9])!
+ SnailFishNumber([1,[[[9,3],9],[[9,0],[0,7]]]])!
+ SnailFishNumber([[[5,[7,4]],7],1])!
+ SnailFishNumber([[[[4,2],2],6],[8,7]])!
*/

/*
SnailFishNumber([9,1])?.magnitude
SnailFishNumber([1,9])?.magnitude
SnailFishNumber([[9,1],[1,9]])?.magnitude
SnailFishNumber([[1,2],[[3,4],5]])?.magnitude
SnailFishNumber([[[[0,7],4],[[7,8],[6,0]]],[8,1]])?.magnitude
SnailFishNumber([[[[1,1],[2,2]],[3,3]],[4,4]])?.magnitude
SnailFishNumber([[[[3,0],[5,3]],[4,4]],[5,5]])?.magnitude
SnailFishNumber([[[[5,0],[7,4]],[5,5]],[6,6]])?.magnitude
SnailFishNumber([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])?.magnitude

let exampleHomework = SnailFishNumber([[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]])!
+ SnailFishNumber([[[5,[2,8]],4],[5,[[9,9],0]]])!
+ SnailFishNumber([6,[[[6,2],[5,6]],[[7,6],[4,7]]]])!
+ SnailFishNumber([[[6,[0,7]],[0,9]],[4,[9,[9,0]]]])!
+ SnailFishNumber([[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]])!
+ SnailFishNumber([[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]])!
+ SnailFishNumber([[[[5,4],[7,7]],8],[[8,3],8]])!
+ SnailFishNumber([[9,3],[[9,9],[6,[4,9]]]])!
+ SnailFishNumber([[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]])!
+ SnailFishNumber([[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]])!

exampleHomework.magnitude
 */

/*
let exampleInput: [Any] = [
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],
    [[[5,[2,8]],4],[5,[[9,9],0]]],
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]],
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]],
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]],
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]],
    [[[[5,4],[7,7]],8],[[8,3],8]],
    [[9,3],[[9,9],[6,[4,9]]]],
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]],
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
]

var largestMagnitude = 0

for (firstIndex, firstAny) in exampleInput.enumerated() {
    for (secondIndex, secondAny) in exampleInput.enumerated() {
        guard firstIndex != secondIndex else { continue }
        
        guard
            let firstNumber = SnailFishNumber(firstAny),
            let secondNumber = SnailFishNumber(secondAny)
        else { continue }
        
        let added = firstNumber + secondNumber
        
        let addedMagnitude = added.magnitude
        
        if addedMagnitude > largestMagnitude {
            largestMagnitude = addedMagnitude
        }
    }
}

largestMagnitude // 3993 (correct)
*/
