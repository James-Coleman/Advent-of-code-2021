import Foundation

var greeting = "Hello, playground"

func polymerRules(from input: String) -> [[Character]: Character] {
    var dict = [[Character]: Character]()
    
    let lines = input.components(separatedBy: .newlines)
    
    for line in lines {
        let components = line.components(separatedBy: .whitespaces)
        let key = components[0].map { $0 }
        guard let value = components[2].map({ $0 }).first else { continue }
        dict[key] = value
    }
    
    return dict
}

let exampleInput = """
    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """

let examplePolyerRules = polymerRules(from: exampleInput)

func polymerPairs(from input: String) -> [[Character]: Int] {
    var dict = [[Character]: Int]()
    
    let characterArray = input.map { $0 }
    
    for i in 0...input.count - 2 {
        let slice = Array(characterArray[i...i+1])
        
        if let value = dict[slice] {
            dict[slice] = value + 1
        } else {
            dict[slice] = 1
        }
        
    }
    
    return dict
}

polymerPairs(from: "NNCB")
