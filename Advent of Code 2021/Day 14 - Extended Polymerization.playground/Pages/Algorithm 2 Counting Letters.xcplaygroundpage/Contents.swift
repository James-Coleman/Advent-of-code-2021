import Foundation

var greeting = "Hello, playground"

struct CharacterPair {
    let first: Character
    let second: Character
    
    init?(_ input: [Character]) {
        guard input.count == 2, let first = input.first, let last = input.last else { return nil }
        
        self.first = first
        self.second = last
    }
}

extension CharacterPair: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(second)
    }
}

extension CharacterPair: Comparable {
    static func < (lhs: CharacterPair, rhs: CharacterPair) -> Bool {
        if lhs.first == rhs.first {
            if lhs.second == rhs.second {
                return lhs.first < rhs.second
            } else {
                return lhs.second < rhs.second
            }
        } else {
            return lhs.first < rhs.first
        }
    }
}

extension CharacterPair: CustomStringConvertible {
    var description: String { "\(first)\(second)" }
}

extension CharacterPair: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any { "\(first)\(second)" }
}

typealias Rules = [CharacterPair: Character]

func polymerRules(from input: String) -> Rules {
    var rules = Rules()
    
    let lines = input.components(separatedBy: .newlines)
    
    for line in lines {
        let components = line.components(separatedBy: .whitespaces)
        guard let key = CharacterPair(components[0].map { $0 }) else { continue }
        guard let value = components[2].map({ $0 }).first else { continue }
        rules[key] = value
    }
    
    return rules
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

let examplePolymerRules = polymerRules(from: exampleInput)

typealias PairCount = [CharacterPair: Int]
typealias CharacterCount = [Character: Int]
typealias Counts = (pairs: PairCount, characters: CharacterCount)

func polymerPairs(from input: String) -> Counts {
    var pairCounts = PairCount()
    var characterCounts = CharacterCount()
    
    let characterArray = input.map { $0 }
    
    for i in 0...input.count - 2 {
//    for (i, character) in input.enumerated() {
        guard i <= input.count - 2 else { break }
        guard let characterPair = CharacterPair(Array(characterArray[i...i+1])) else { continue }
        
        if let value = pairCounts[characterPair] {
            pairCounts[characterPair] = value + 1
        } else {
            pairCounts[characterPair] = 1
        }
        
        if i == 0 {
            // Count both
            if characterPair.first == characterPair.second {
                characterCounts[characterPair.first] = 2
            } else {
                characterCounts[characterPair.first] = 1
                characterCounts[characterPair.second] = 1
            }
        } else {
            // Only need to count the second
            if let count = characterCounts[characterPair.second] {
                characterCounts[characterPair.second] = count + 1
            } else {
                characterCounts[characterPair.second] = 1
            }
        }
        
    }
    
    return (pairCounts, characterCounts)
}

let exampleTemplatePairs = polymerPairs(from: "NNCB")

func nextStep(from input: Counts, rules: Rules) -> Counts {
    var newPairCounts = PairCount()
    var newCharacterCounts = input.characters
    
    for (key, value) in input.pairs {
        if let character = rules[key] {
            guard
                let newPair1 = CharacterPair([key.first, character]),
                let newPair2 = CharacterPair([character, key.second])
            else { continue }
            
            if let count = newPairCounts[newPair1] {
                newPairCounts[newPair1] = count + value
            } else {
                newPairCounts[newPair1] = value
            }
            
            if let count = newPairCounts[newPair2] {
                newPairCounts[newPair2] = count + value
            } else {
                newPairCounts[newPair2] = value
            }
            
            if let count = newCharacterCounts[character] {
                newCharacterCounts[character] = count + value
            } else {
                newCharacterCounts[character] = value
            }
        }
    }
    
    return (newPairCounts, newCharacterCounts)
}

nextStep(from: exampleTemplatePairs, rules: examplePolymerRules)

func generation(_ generation: Int, from input: Counts, rules: Rules) -> Counts {
    var newPairs = input
    
    for _ in 1...generation {
        newPairs = nextStep(from: newPairs, rules: rules)
    }
    
    return newPairs
}

/*
let exampleGeneration10 = generation(10, from: exampleTemplatePairs, rules: examplePolymerRules)

let exampleGen10Sorted = exampleGeneration10.characters.sorted(by: { $0.value > $1.value })

if let biggest = exampleGen10Sorted.first, let smallest = exampleGen10Sorted.last {
    biggest.value - smallest.value // 1588 (correct)
}

let exampleGeneration40 = generation(40, from: exampleTemplatePairs, rules: examplePolymerRules)

let exampleGen40Sorted = exampleGeneration40.characters.sorted(by: { $0.value > $1.value })

if let biggest = exampleGen40Sorted.first, let smallest = exampleGen40Sorted.last {
    biggest.value - smallest.value // 2188189693529 (correct)
}
 */


