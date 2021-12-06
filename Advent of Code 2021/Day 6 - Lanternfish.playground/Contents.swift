import Cocoa

var greeting = "Hello, playground"

func nextGeneration(of array: [Int]) -> [Int] {
    var array = array
    
    for (index, fishLife) in array.enumerated() {
        array[index] = fishLife - 1
        
        if array[index] == -1 {
            array += [8]
            array[index] = 6
        }
    }
    
    return array
}

nextGeneration(of: [3,4,3,1,2])
nextGeneration(of: [2,3,2,0,1])
nextGeneration(of: [1,2,1,6,0,8])

func generation(after: Int, initial: [Int]) -> [Int] {
    var arrayToReturn = initial
    
    for i in 1...after {
        arrayToReturn = nextGeneration(of: arrayToReturn)
    }
    
    return arrayToReturn
}

//let lastGeneration = generation(after: 80, initial: [3,4,3,1,2])
//lastGeneration.count // 5934 (correct)

let puzzleInput = [1,1,1,3,3,2,1,1,1,1,1,4,4,1,4,1,4,1,1,4,1,1,1,3,3,2,3,1,2,1,1,1,1,1,1,1,3,4,1,1,4,3,1,2,3,1,1,1,5,2,1,1,1,1,2,1,2,5,2,2,1,1,1,3,1,1,1,4,1,1,1,1,1,3,3,2,1,1,3,1,4,1,2,1,5,1,4,2,1,1,5,1,1,1,1,4,3,1,3,2,1,4,1,1,2,1,4,4,5,1,3,1,1,1,1,2,1,4,4,1,1,1,3,1,5,1,1,1,1,1,3,2,5,1,5,4,1,4,1,3,5,1,2,5,4,3,3,2,4,1,5,1,1,2,4,1,1,1,1,2,4,1,2,5,1,4,1,4,2,5,4,1,1,2,2,4,1,5,1,4,3,3,2,3,1,2,3,1,4,1,1,1,3,5,1,1,1,3,5,1,1,4,1,4,4,1,3,1,1,1,2,3,3,2,5,1,2,1,1,2,2,1,3,4,1,3,5,1,3,4,3,5,1,1,5,1,3,3,2,1,5,1,1,3,1,1,3,1,2,1,3,2,5,1,3,1,1,3,5,1,1,1,1,2,1,2,4,4,4,2,2,3,1,5,1,2,1,3,3,3,4,1,1,5,1,3,2,4,1,5,5,1,4,4,1,4,4,1,1,2]

let puzzleLastGeneration = generation(after: 80, initial: puzzleInput)
puzzleLastGeneration.count


