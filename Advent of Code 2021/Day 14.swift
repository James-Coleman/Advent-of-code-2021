//
//  Day 14.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 14/12/2021.
//

import Foundation

func day14() {
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
    
    func score(for input: [Character], rules: [[Character]: Character], generations: Int) -> Int? {
        
        var copy = input
        
        for i in 1...generations {
            print("Starting generation \(i)")
            copy = nextGeneration(after: copy, using: rules)
        }
        
        let countedSet = NSCountedSet(array: copy)
        
        let counts = countedSet.map { countedSet.count(for: $0) }
        
        let sorted = counts.sorted()
        
        guard let last = sorted.last, let first = sorted.first else { return nil }
        
        return last - first
    }
    
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
    
    print(score(for: puzzleStart, rules: puzzleRules, generations: 40))
}
