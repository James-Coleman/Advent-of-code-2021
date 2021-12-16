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

func answer(from input: CharacterCount) -> Int? {
    let sorted = input.sorted(by: { $0.value > $1.value })
    
    guard let biggest = sorted.first, let smallest = sorted.last else { return nil }
    
    return biggest.value - smallest.value
}


let exampleGeneration10 = generation(10, from: exampleTemplatePairs, rules: examplePolymerRules)

answer(from: exampleGeneration10.characters) // 1588 (correct)

let exampleGeneration40 = generation(40, from: exampleTemplatePairs, rules: examplePolymerRules)

answer(from: exampleGeneration40.characters) // 2188189693529 (correct)

let puzzlePairs = polymerPairs(from: "PFVKOBSHPSPOOOCOOHBP")
let puzzleRulesInput = """
    FV -> C
    CP -> K
    FS -> K
    VF -> N
    HN -> F
    FF -> N
    SS -> K
    VS -> V
    BV -> F
    HC -> K
    BP -> F
    OV -> N
    BF -> V
    VH -> V
    PF -> N
    FC -> S
    CS -> B
    FK -> N
    VK -> H
    FN -> P
    SH -> V
    CV -> K
    HP -> K
    HO -> C
    NO -> V
    CK -> C
    VB -> S
    OC -> N
    NS -> C
    NF -> H
    SF -> N
    NK -> S
    NP -> P
    OO -> S
    NH -> C
    BC -> H
    KS -> H
    PV -> O
    KO -> K
    OK -> H
    OH -> H
    BH -> F
    NB -> B
    FH -> N
    HV -> F
    BN -> S
    ON -> V
    CB -> V
    CF -> H
    FB -> S
    KF -> S
    PS -> P
    OB -> C
    NN -> K
    KV -> C
    BK -> H
    SN -> S
    NC -> H
    PK -> B
    PC -> H
    KN -> S
    VO -> V
    FO -> K
    CH -> B
    PH -> N
    SO -> C
    KH -> S
    HB -> V
    HH -> B
    BB -> H
    SC -> V
    HS -> K
    SP -> V
    KB -> N
    VN -> H
    HK -> H
    KP -> K
    OP -> F
    CO -> B
    VP -> H
    OS -> N
    OF -> H
    KK -> N
    CC -> K
    BS -> C
    VV -> O
    CN -> H
    PB -> P
    BO -> N
    SB -> H
    FP -> F
    SK -> F
    PO -> S
    KC -> H
    VC -> H
    NV -> N
    HF -> B
    PN -> F
    SV -> K
    PP -> K
    """

let puzzleRules = polymerRules(from: puzzleRulesInput)

let puzzleGen10 = generation(10, from: puzzlePairs, rules: puzzleRules)

answer(from: puzzleGen10.characters) // 2937 (correct)

let puzzleGen40 = generation(40, from: puzzlePairs, rules: puzzleRules)

answer(from: puzzleGen40.characters) // 3390034818249 (correct)
