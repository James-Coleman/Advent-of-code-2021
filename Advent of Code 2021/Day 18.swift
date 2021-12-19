//
//  Day 18.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 19/12/2021.
//

import Foundation

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

func day18() {
    let puzzleInput = SnailFishNumber([[[6,6],3],0])!
    + SnailFishNumber([[[0,[9,9]],[[7,7],[4,6]]],[[5,6],[5,9]]])!
    + SnailFishNumber([[[1,[6,5]],7],[[6,[3,6]],5]])!
    + SnailFishNumber([[0,[9,[0,2]]],[[[1,9],3],[[0,1],[5,1]]]])!
    + SnailFishNumber([[[3,[7,6]],[1,0]],[[4,[7,9]],[5,4]]])!
    + SnailFishNumber([[0,9],[[[0,3],[2,9]],3]])!
    + SnailFishNumber([[[[3,2],0],[7,6]],[9,[[4,6],0]]])!
    + SnailFishNumber([[4,[[2,5],[4,0]]],[2,[8,[3,0]]]])!
    + SnailFishNumber([[[[3,5],6],[[8,6],2]],[[6,[5,1]],[[1,0],[3,2]]]])!
    + SnailFishNumber([[1,[[2,8],[2,9]]],[[7,[8,8]],[[2,1],[9,5]]]])!
    + SnailFishNumber([[[4,[4,6]],[[5,7],4]],[8,0]])!
    + SnailFishNumber([[[3,[5,9]],[1,[6,5]]],[1,9]])!
    + SnailFishNumber([[[5,7],[4,1]],4])!
    + SnailFishNumber([3,[[6,0],[[9,0],[8,2]]]])!
    + SnailFishNumber([[7,[[5,4],[7,3]]],[6,[[9,0],[1,9]]]])!
    + SnailFishNumber([[[9,3],[0,[1,4]]],[[8,0],9]])!
    + SnailFishNumber([[7,3],[[4,2],0]])!
    + SnailFishNumber([[[[1,6],8],1],[[[3,6],[9,9]],9]])!
    + SnailFishNumber([[[[2,7],[1,6]],[2,6]],0])!
    + SnailFishNumber([[[2,[0,8]],8],[[9,7],5]])!
    + SnailFishNumber([4,[[6,3],[9,5]]])!
    + SnailFishNumber([[[4,[0,8]],3],[[2,9],[[5,3],[2,5]]]])!
    + SnailFishNumber([[1,0],[[6,[9,0]],[[6,3],9]]])!
    + SnailFishNumber([[[[0,6],[1,1]],[[2,9],2]],[[2,0],3]])!
    + SnailFishNumber([[[6,8],[[1,1],9]],[6,5]])!
    + SnailFishNumber([1,[5,9]])!
    + SnailFishNumber([[[[6,8],[4,6]],[[8,2],[9,2]]],[[3,[6,8]],[4,3]]])!
    + SnailFishNumber([8,[[[2,4],[1,1]],[[7,1],[3,4]]]])!
    + SnailFishNumber([[[[1,9],5],[[8,6],9]],[[[3,7],[9,6]],[2,0]]])!
    + SnailFishNumber([[[7,[2,7]],[[2,9],7]],[4,[5,[9,5]]]])!
    + SnailFishNumber([9,[[[1,9],7],[[8,7],[2,8]]]])!
    + SnailFishNumber([9,2])!
    + SnailFishNumber([[7,[1,[2,8]]],[9,5]])!
    + SnailFishNumber([[[0,[5,4]],6],[8,1]])!
    + SnailFishNumber([[[0,[9,8]],0],5])!
    + SnailFishNumber([[9,[2,9]],[1,[8,[3,8]]]])!
    + SnailFishNumber([3,[[5,5],[2,[2,5]]]])!
    + SnailFishNumber([[6,7],[[[7,3],3],8]])!
    + SnailFishNumber([[[[6,7],[2,6]],7],[0,[6,[3,5]]]])!
    + SnailFishNumber([2,[[9,2],[[8,5],[1,2]]]])!
    + SnailFishNumber([0,[[[0,8],[9,7]],[[5,1],7]]])!
    + SnailFishNumber([[[2,1],6],[[9,[0,9]],[2,6]]])!
    + SnailFishNumber([4,[9,[[5,2],[6,3]]]])!
    + SnailFishNumber([[[9,1],4],[[6,[5,6]],[5,8]]])!
    + SnailFishNumber([[4,[[1,5],[5,4]]],[3,[[7,2],7]]])!
    + SnailFishNumber([[[4,5],6],[9,[9,1]]])!
    + SnailFishNumber([3,[7,[5,2]]])!
    + SnailFishNumber([[[0,[6,6]],[[7,8],[0,8]]],[2,[[0,5],8]]])!
    + SnailFishNumber([[[[2,3],[0,6]],[[6,0],[9,4]]],[[[1,6],1],[[5,6],9]]])!
    + SnailFishNumber([[[1,[2,2]],[9,[8,2]]],[[[2,9],0],[5,[2,7]]]])!
    + SnailFishNumber([[[2,[4,9]],[2,[0,0]]],[[2,[9,7]],[[3,4],[0,7]]]])!
    + SnailFishNumber([[1,[7,[3,5]]],[[7,[5,8]],1]])!
    + SnailFishNumber([[[[2,3],1],[5,3]],[[0,[1,8]],[1,2]]])!
    + SnailFishNumber([[6,9],[0,[[8,8],4]]])!
    + SnailFishNumber([[[8,[9,1]],[[0,1],6]],[[8,8],[2,4]]])!
    + SnailFishNumber([[0,[[5,1],[5,8]]],[[5,[5,1]],2]])!
    + SnailFishNumber([[[8,[8,4]],8],[[2,[6,0]],[[5,8],6]]])!
    + SnailFishNumber([5,[[1,[3,6]],[[5,8],[5,0]]]])!
    + SnailFishNumber([8,[[5,[7,8]],[[9,9],[8,4]]]])!
    + SnailFishNumber([2,[[[7,6],7],[[9,4],[8,9]]]])!
    + SnailFishNumber([[5,9],[[8,[2,9]],[0,[2,8]]]])!
    + SnailFishNumber([[[2,[7,4]],5],3])!
    + SnailFishNumber([[[7,[1,1]],5],[[4,[7,2]],[[5,8],[2,8]]]])!
    + SnailFishNumber([[[1,[2,8]],6],7])!
    + SnailFishNumber([[[[2,7],[0,0]],[[5,3],5]],[[[1,1],[4,6]],7]])!
    + SnailFishNumber([[[4,6],[1,[5,0]]],8])!
    + SnailFishNumber([[[8,[5,3]],2],[[[0,2],[3,6]],[[7,9],[8,0]]]])!
    + SnailFishNumber([[[2,[2,0]],5],[[[5,8],[0,1]],[8,[8,5]]]])!
    + SnailFishNumber([[[9,[0,7]],[[5,0],[9,6]]],0])!
    + SnailFishNumber([[[[1,6],4],[1,4]],[[[5,8],4],[[9,9],[9,7]]]])!
    + SnailFishNumber([1,1])!
    + SnailFishNumber([[4,4],[[6,3],9]])!
    + SnailFishNumber([[[[4,0],[6,8]],[[6,0],0]],[8,[[7,9],7]]])!
    + SnailFishNumber([[[[1,1],6],[[4,1],[6,4]]],4])!
    + SnailFishNumber([[[[9,5],[5,8]],2],[[3,[8,8]],[[7,0],8]]])!
    + SnailFishNumber([[[[9,3],4],[3,[9,2]]],[[2,7],[7,[2,3]]]])!
    + SnailFishNumber([[[[6,8],[7,4]],[[1,6],1]],[3,4]])!
    + SnailFishNumber([[1,[2,[8,6]]],5])!
    + SnailFishNumber([[[[7,5],[2,5]],[[5,3],[0,3]]],[4,9]])!
    + SnailFishNumber([[8,7],[[2,[1,6]],[[4,8],1]]])!
    + SnailFishNumber([[9,[[0,7],[7,2]]],4])!
    + SnailFishNumber([[4,[8,[9,6]]],[[[8,1],[3,5]],8]])!
    + SnailFishNumber([[[[9,1],[2,2]],[[7,9],0]],[[8,[0,6]],[0,[7,3]]]])!
    + SnailFishNumber([[[2,[8,7]],[[9,0],1]],[8,[9,0]]])!
    + SnailFishNumber([1,[3,2]])!
    + SnailFishNumber([[[[6,3],7],[[5,3],[3,1]]],[4,[[9,3],5]]])!
    + SnailFishNumber([3,[1,9]])!
    + SnailFishNumber([3,[[[6,4],[0,2]],[[3,8],[5,3]]]])!
    + SnailFishNumber([[[[3,4],3],[[4,6],4]],[[[5,7],7],3]])!
    + SnailFishNumber([[[5,1],[[1,0],4]],[[2,3],[0,2]]])!
    + SnailFishNumber([[[[2,4],[8,0]],5],[[1,2],[6,[2,3]]]])!
    + SnailFishNumber([[[2,9],4],4])!
    + SnailFishNumber([[8,[[6,2],[1,3]]],[8,[[6,3],[4,9]]]])!
    + SnailFishNumber([[[[2,7],9],[[5,6],[3,4]]],[5,9]])!
    + SnailFishNumber([[[[5,5],9],1],2])!
    + SnailFishNumber([[[[9,7],[6,9]],[[6,8],[3,9]]],[6,[3,8]]])!
    + SnailFishNumber([[9,3],[[6,0],5]])!
    + SnailFishNumber([[[[5,1],4],[[2,8],7]],[[[9,8],6],[[1,5],[4,0]]]])!
    + SnailFishNumber([[[4,5],3],[[3,[5,9]],[7,[9,2]]]])!
    + SnailFishNumber([[[[1,7],5],[0,[2,2]]],[[3,6],[9,6]]])!
    
    print(puzzleInput.magnitude) // 4124 (correct)
}
