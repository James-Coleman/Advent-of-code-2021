import Foundation

var greeting = "Hello, playground"

let test = NSCountedSet(array: [3,4,3,1,2])

test.count
test.count(for: 3)
test.count(for: 4)
test.remove(3)
test.count(for: 3)

let exampleDict = [3: 2, 4: 1, 1: 1, 2: 1]

func nextDict(after dict: [Int: Int]) -> [Int: Int] {
    var dictToReturn = [Int: Int]()
    
    var numberOfSixes = 0
    
    for (key, value) in dict {
        if key == 0 {
            dictToReturn[8] = value
            numberOfSixes += value
        } else if key == 7 {
            numberOfSixes += value
        } else {
            dictToReturn[key - 1] = value
        }
    }
    
    if numberOfSixes != 0 {
        dictToReturn[6] = numberOfSixes
    }
    
    return dictToReturn
}

nextDict(after: exampleDict)
nextDict(after: [2: 2, 1: 1, 3: 1, 0: 1])
nextDict(after: [8: 1, 0: 1, 2: 1, 1: 2, 6: 1])

func countAfter(days: Int, from initial: [Int: Int]) -> Int {
    var dict = initial
    
    for _ in 1...days {
        dict = nextDict(after: dict)
    }
    
    let count = dict.values.reduce(0, +)
    
    return count
}

countAfter(days: 18, from: exampleDict)
countAfter(days: 80, from: exampleDict)

let puzzleInput = [1,1,1,3,3,2,1,1,1,1,1,4,4,1,4,1,4,1,1,4,1,1,1,3,3,2,3,1,2,1,1,1,1,1,1,1,3,4,1,1,4,3,1,2,3,1,1,1,5,2,1,1,1,1,2,1,2,5,2,2,1,1,1,3,1,1,1,4,1,1,1,1,1,3,3,2,1,1,3,1,4,1,2,1,5,1,4,2,1,1,5,1,1,1,1,4,3,1,3,2,1,4,1,1,2,1,4,4,5,1,3,1,1,1,1,2,1,4,4,1,1,1,3,1,5,1,1,1,1,1,3,2,5,1,5,4,1,4,1,3,5,1,2,5,4,3,3,2,4,1,5,1,1,2,4,1,1,1,1,2,4,1,2,5,1,4,1,4,2,5,4,1,1,2,2,4,1,5,1,4,3,3,2,3,1,2,3,1,4,1,1,1,3,5,1,1,1,3,5,1,1,4,1,4,4,1,3,1,1,1,2,3,3,2,5,1,2,1,1,2,2,1,3,4,1,3,5,1,3,4,3,5,1,1,5,1,3,3,2,1,5,1,1,3,1,1,3,1,2,1,3,2,5,1,3,1,1,3,5,1,1,1,1,2,1,2,4,4,4,2,2,3,1,5,1,2,1,3,3,3,4,1,1,5,1,3,2,4,1,5,5,1,4,4,1,4,4,1,1,2]

let puzzleDict = Dictionary(grouping: puzzleInput, by: { $0 }).mapValues { $0.count }

countAfter(days: 80, from: puzzleDict) // 372984 (correct) (and in a split second)
countAfter(days: 256, from: puzzleDict) // 1681503251694 (correct) (and in a split second)
