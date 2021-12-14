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

func nextGeneration(after input: [Character], using rules: [[Character]: Character]) -> [Character] {
    var inputCopy = input
    
    var insertionIndex = 1
    
    for i in 0...input.count - 2 {
        let slice = Array(input[i...i+1])
        
        if let value = rules[slice] {
            inputCopy.insert(value, at: insertionIndex)
            
            insertionIndex += 2
        }
        
    }
    
    return inputCopy
}

//nextGeneration(after: ["N", "N", "C", "B"], using: examplePolyerRules)

func score(for input: [Character], rules: [[Character]: Character]) -> Int? {
    
    var copy = input
    
    for i in 1...10 {
        copy = nextGeneration(after: copy, using: rules)
    }
    
    let countedSet = NSCountedSet(array: copy)
    
    let counts = countedSet.map { countedSet.count(for: $0) }
    
    let sorted = counts.sorted()
    
    guard let last = sorted.last, let first = sorted.first else { return nil }
    
    return last - first
}

//score(for: ["N", "N", "C", "B"], rules: examplePolyerRules) // 1588 (correct)

let puzzleInput = """
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

let puzzleRules = polymerRules(from: puzzleInput)

let puzzleStart = "PFVKOBSHPSPOOOCOOHBP".map { $0 }

//score(for: puzzleStart, rules: puzzleRules) // 2937 (correct)
