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

let examplePolyerRules = polymerRules(from: exampleInput)

typealias PairCount = [CharacterPair: Int]

func polymerPairs(from input: String) -> PairCount {
    var counts = PairCount()
    
    let characterArray = input.map { $0 }
    
    for i in 0...input.count - 2 {
        guard let slice = CharacterPair(Array(characterArray[i...i+1])) else { continue }
        
        if let value = counts[slice] {
            counts[slice] = value + 1
        } else {
            counts[slice] = 1
        }
        
    }
    
    return counts
}

let exampleTemplatePairs = polymerPairs(from: "NNCB")

func nextStep(from input: PairCount, rules: Rules) -> PairCount {
    var counts = PairCount()
    
    for (key, value) in input {
        if let character = rules[key] {
            guard
                let newPair1 = CharacterPair([key.first, character]),
                let newPair2 = CharacterPair([character, key.second])
            else { continue }
            
            if let count = counts[newPair1] {
                counts[newPair1] = count + value
            } else {
               counts[newPair1] = value
            }
            
            if let count = counts[newPair2] {
                counts[newPair2] = count + value
            } else {
               counts[newPair2] = value
            }
        }
    }
    
    return counts
}

extension PairCount {
    func debugSorted() -> [(CharacterPair, Int)]  {
        self.sorted(by: { $0.key < $1.key })
    }
}

let exampleStep1 = nextStep(from: exampleTemplatePairs, rules: examplePolyerRules)
let debugStep1 = polymerPairs(from: "NCNBCHB")
exampleStep1 == debugStep1
let exampleStep2 = nextStep(from: exampleStep1, rules: examplePolyerRules)
let debugStep2 = polymerPairs(from: "NBCCNBBBCBHCB")
exampleStep2 == debugStep2
let exampleStep3 = nextStep(from: exampleStep2, rules: examplePolyerRules)
let debugStep3 = polymerPairs(from: "NBBBCNCCNBBNBNBBCHBHHBCHB")
exampleStep3 == debugStep3
let exampleStep4 = nextStep(from: exampleStep3, rules: examplePolyerRules)
let debugStep4 = polymerPairs(from: "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB")
exampleStep4 == debugStep4

func generation(_ generation: Int, from input: PairCount, rules: Rules) -> PairCount {
    var pairCount = input
    
    for _ in 1...generation {
        pairCount = nextStep(from: pairCount, rules: rules)
    }
    
    return pairCount
}

let exampleGeneration10 = generation(10, from: exampleTemplatePairs, rules: examplePolyerRules)

extension PairCount {
    var elementCount: [Character: Int] {
        var dict = [Character: Int]()
        
        for (key, value) in self {
            let firstCharacter = key.first
            let secondCharacter = key.second
            
            if let count = dict[firstCharacter] {
                dict[firstCharacter] = count + value
            } else {
                dict[firstCharacter] = value
            }
            
            if let count = dict[secondCharacter] {
                dict[secondCharacter] = count + value
            } else {
                dict[secondCharacter] = value
            }
        }
        
        return dict
    }
}

let exampleElementCount = exampleGeneration10.elementCount

if let nCount = exampleElementCount["N"], let hCount = exampleElementCount["H"], let bCount = exampleElementCount["B"], let cCount = exampleElementCount["C"] {
    // If it's even does that mean it wasn't an end Character?
    nCount / 2
    hCount / 2
    bCount / 2
    cCount / 2
}
