import Foundation

var greeting = "Hello, playground"

let exampleInput = """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """

func gammaEpsilon(from: String) -> (gamma: String, epsilon: String) {
    /// Most common
    var gamma = ""
    /// Least common
    var epsilon = ""

    let binaryStrings = from.components(separatedBy: .newlines)
    
    guard let length = binaryStrings.first?.count else { return (gamma, epsilon) }
    
    for index in 0..<length {
        var zeroCount = 0
        var oneCount = 0
        
        for string in binaryStrings {
            let number = string[String.Index(encodedOffset: index)]
            
            if number == "0" {
                zeroCount += 1
            } else if number == "1" {
                oneCount += 1
            } else {
                print("Found unexpected number: \(number)")
            }
        }
        
        if zeroCount > oneCount {
            gamma += "0"
            epsilon += "1"
        } else {
            gamma += "1"
            epsilon += "0"
        }
    }

    return (gamma, epsilon)

}

let (exampleGamma, exampleEpsilon) = gammaEpsilon(from: exampleInput) // (gamma "10110", epsilon "01001") (correct)

if let exampleGammaInt = Int(exampleGamma, radix: 2), let exampleEpsilonInt = Int(exampleEpsilon, radix: 2) {
    exampleGammaInt * exampleEpsilonInt // 198 (correct)
}

let challengeInput = """
    001001100101
    010100011100
    100000110001
    001111110101
    100010110101
    111010100100
    011011000110
    100000011101
    011001100111
    000001011110
    000010100011
    110100111110
    001101100101
    011011011101
    010000011010
    011100100100
    001111000011
    100111000111
    100111100011
    101100011011
    001110101101
    110010101000
    111110110111
    111100100010
    001001000000
    001111101011
    101100110011
    011010001111
    100010100001
    110011001010
    101000001100
    111010101100
    101010101100
    110011101000
    001110010110
    010101001001
    000010101100
    010101101010
    111001101100
    010000000000
    011011111000
    001110110011
    101000001011
    110101100101
    111001010111
    110001111111
    010010100110
    011010011001
    011101100000
    100110010101
    111000101101
    110011110000
    011001011000
    001101000010
    001110011111
    100010101100
    010011100101
    000011110000
    101100001111
    010001011000
    001101011101
    011110001110
    111110101101
    010000000011
    111000000011
    000100010100
    111110011001
    111001010011
    011000100010
    100001110000
    111111000100
    010100101110
    010011100110
    101100110111
    101001101001
    000001110111
    101100000001
    011010111011
    110011011111
    001001011001
    010110101100
    001100101100
    101001011101
    100101000010
    010101000010
    111101011110
    000000100010
    111010010010
    100001111011
    110000010011
    000101111001
    111101100111
    110101011100
    000111110101
    011110111001
    010000101011
    001001011000
    010110011100
    111111111000
    110100000101
    110101010011
    010011110010
    100110111100
    111000001101
    110001001001
    111101111100
    111111101001
    100101001010
    010101010100
    010010001111
    000010110000
    011001110110
    111101111011
    011001011100
    110101010101
    110111011111
    110101111000
    110010100110
    110000000010
    011001100001
    011000110010
    010110100000
    011110000001
    100101011010
    100111111011
    001110000011
    100110011011
    000100011101
    110000110110
    000001000010
    011111111010
    001010100100
    011000100100
    001100001111
    010111100111
    010001101101
    011001010000
    001010101000
    001001100011
    000011001010
    010010010100
    100001011000
    000011011011
    111011110111
    100010010000
    111001110000
    011100010100
    000101101011
    010000000010
    001101110100
    111010111111
    011000011110
    111110000110
    011011011011
    010001000100
    110111010010
    001110010100
    001001011010
    010111100011
    110110110101
    110101000101
    001011100011
    001111010110
    110111011000
    110001011110
    011101000001
    101111100000
    110001101110
    010101101100
    010010100010
    000111101010
    010000001010
    011001000010
    100000010110
    111101010010
    111011001011
    000010100010
    011111111001
    111001001011
    101001111010
    110100000001
    010010101111
    110011111001
    110111100110
    100111001111
    100101101001
    011111100100
    011111011011
    111100101101
    110010000111
    110110010000
    011101111011
    001101101000
    001001100110
    110001101000
    111100101110
    000101110111
    011110101111
    000100010010
    011010000011
    010010100001
    111001111110
    001111101010
    101110100011
    100111111001
    110110011010
    000100001000
    111011010010
    011001101110
    001011011010
    101110111100
    110011010110
    001010100011
    111010111110
    011100010011
    100011010100
    110000111010
    110001010001
    001111101001
    010011100111
    101010111010
    110101001101
    000100111000
    100101001001
    101110111011
    001110011000
    011000010010
    001000010001
    000111011101
    100000111100
    001110000100
    011111111100
    000100100100
    100101001000
    100011011110
    011110100010
    011110111110
    010001010110
    000101000000
    001001100000
    010001101100
    110010110101
    100001000010
    100001001001
    000111000011
    111000100010
    000000011101
    111111000110
    100111100100
    111100011101
    101011110011
    001010110101
    100000000110
    111100011001
    010110010010
    000010010010
    001011111001
    001000011100
    011000011000
    111111110000
    100001110010
    011011110010
    000110011101
    001101001010
    011010100111
    100000011100
    001000111011
    011010100110
    000001111111
    001010010111
    011100001010
    110110001000
    110010101111
    111100010111
    100001111010
    101110010110
    000010110011
    111001010100
    101101110110
    111111111100
    011101101011
    011011110100
    111010100011
    001101000110
    111101111001
    110001111000
    010110000111
    110110100101
    111101011100
    100001000011
    010011101000
    000111110000
    111011110100
    011010111110
    101011001000
    111100110101
    100100001001
    100011110100
    010101010011
    010110011011
    100111001101
    000111001010
    110111011011
    100000111011
    111011000001
    011111100011
    110010000010
    100110101111
    101001111000
    111001111010
    000111111000
    111110100100
    111001111011
    100010110111
    110111001111
    100011001001
    110011001101
    100011101111
    011011110000
    101100011110
    110110111011
    011010100000
    111000000010
    000010010011
    110101101001
    101011011101
    011101100110
    111111000010
    010110100101
    010010011110
    010000101111
    010110101001
    001111010101
    111000101110
    100000010111
    111001000101
    111101101100
    011000000110
    000001110010
    110011010001
    011110011011
    100000010001
    000100100001
    011110001100
    001101011111
    100000000001
    000010011001
    110111000110
    100110110111
    011000110000
    100101000101
    100100111110
    000101010100
    001110100111
    111011001010
    010111001001
    110101001110
    111000100111
    000101011100
    100010111000
    000111110111
    010110010100
    110101100100
    111000011111
    000101001100
    000001011111
    011001111101
    110001111001
    111111110100
    010100111111
    011001100110
    010110101101
    011111011001
    101000010100
    010001100101
    101000100101
    001001010010
    000100011000
    000000000111
    001110011001
    100000001011
    011011101001
    111001000000
    110011100000
    011001100011
    000010011100
    000111000000
    000110011111
    010100011101
    001100010111
    100011000001
    001011000110
    010000011111
    011101001100
    101111011110
    000101001001
    110100101100
    000100010101
    010011001000
    010000010100
    111111010000
    000101000111
    000010010110
    001010000001
    100110110010
    010101100010
    111110010100
    111011111110
    010110110101
    011111000011
    001001001000
    101100001101
    100010101001
    010001101011
    000011011101
    010110011111
    101001001010
    100100001111
    100110100011
    000101001010
    100000100101
    011000100110
    110100000110
    000000010101
    000011110010
    100010010101
    001000100111
    111010000101
    000011000010
    000101001110
    000100110000
    101110010001
    101110100100
    111111001101
    111011101110
    010011000100
    000001001000
    100010111110
    111100101001
    001011111101
    000110000011
    100111111100
    111000000110
    001001011110
    111011110000
    110110000110
    110110011100
    010111111010
    011011001110
    110110001100
    000111100010
    011001100101
    111111000011
    011001111000
    110111010100
    000011111010
    011111101001
    011001011010
    010111101101
    001100100110
    001110101100
    001011011111
    000110001010
    100100001101
    011001101111
    010000100110
    110110010100
    000000110010
    011000101101
    110101111011
    110011111011
    010010001000
    001101110000
    100111100000
    111001011100
    001000110010
    011000011100
    001110010111
    010111011101
    010001110001
    111111101110
    000010111000
    001001000110
    101101100010
    000010000000
    111100100100
    101111011010
    111110011111
    010011110100
    010010010001
    011100011101
    111100000100
    011110011000
    000101100000
    101000111100
    101011110001
    001010000100
    001100101110
    010101010101
    111101110010
    011110100100
    001101100000
    000000110011
    100101100000
    101111100011
    101010101001
    100110110011
    000110100010
    101010000100
    001011010011
    010100110101
    000011101101
    100001001100
    111101101110
    100111101001
    010110111010
    011110000110
    100101011101
    000000001000
    000111001011
    011001000101
    011101001111
    111010001011
    010011011111
    101100001011
    001110110001
    101110110100
    100100011000
    000111010111
    111011111011
    011011100111
    110000110010
    101110110000
    010001111011
    010011111100
    110100110011
    011000111110
    000010111010
    001110001001
    011001100000
    100100100110
    011111001010
    000101000100
    101001010010
    010011101100
    110100101110
    010110001001
    111000011011
    010001110000
    011111011000
    010011000011
    001100001010
    100011100010
    011011111100
    010110101111
    000101100001
    101101100000
    111000110101
    110011010100
    000111011010
    011111010010
    111011111000
    100101110111
    000000111111
    011100110010
    110110011011
    010001011101
    100110110000
    110111110010
    010001111101
    100001101001
    110000111111
    010111110000
    100011001000
    011000101111
    111100100101
    010111010010
    111100110110
    101001100010
    110100010000
    110010111000
    011100010010
    000000001001
    010100011110
    110101010110
    111100100001
    111000010010
    110000010111
    001011100000
    001001010101
    110101101111
    001010010101
    010000110100
    111001011010
    000001111100
    101101011111
    110100111011
    100111010000
    110001110100
    101011000110
    101100111110
    001010010001
    011111101011
    010100001001
    010110100001
    000000110000
    110010111111
    111010000100
    111100001111
    100100110000
    001000110001
    011010001011
    110101111010
    001110000001
    000010100110
    010101111010
    011110100101
    011011100100
    000000011111
    100010011001
    100101000100
    110010011011
    011000000000
    001111111110
    001111010011
    100000110111
    100011011000
    110011111110
    010001000001
    011100011111
    101110001000
    101110000111
    001101100011
    111100100000
    101001110010
    100011110110
    100110101101
    011101100100
    111001011110
    110001101101
    100101101110
    111101001100
    100100100001
    100000011110
    000000000011
    010100010111
    001010010110
    110010110000
    100011110101
    110110110110
    100101101100
    000111011011
    001001001011
    101111010010
    011011010111
    010001100001
    111110101100
    010100100010
    001101101111
    011111100001
    100011011111
    110011111100
    100110001110
    101010100000
    100111011010
    101110101001
    101111001011
    110111000010
    100110001001
    000011111101
    110100010011
    101001000010
    101101011100
    001110010010
    001111000010
    110011101110
    001010011000
    011001000011
    110001101111
    001011001011
    011001111111
    000101010101
    101101100110
    110100101101
    011000111000
    011110100011
    010101110111
    110010001000
    101110100010
    111010001010
    011000001010
    001010110111
    110011111111
    011111101010
    000101110000
    101101000001
    111110111001
    110010111011
    100111101111
    101111000100
    011101110000
    001101010010
    110110011101
    000110000001
    001011111011
    011100001111
    110010101100
    110010010100
    110010100000
    110110000100
    010110011001
    100101101101
    010010010101
    101011111000
    100001001000
    011100011110
    101110010011
    110110001010
    110010110001
    110000000100
    011000000011
    000011111000
    010111000111
    000111000100
    111101100100
    101000101111
    001000000110
    000100000001
    101001100101
    001001111110
    001000010011
    111100001110
    001010111011
    011110011101
    001111101000
    000001110100
    110101000110
    000101000010
    001110101010
    101101011101
    011100101001
    011110000000
    001001101011
    001001011111
    011101111101
    101111100111
    001110110110
    011010110001
    011111000001
    000100101101
    001010010011
    010010110000
    111011101111
    110110000111
    001011110101
    100001101011
    110101100000
    010011111101
    000101110010
    100100111010
    101101101111
    010110111001
    110100110110
    111111001111
    100110010000
    100010100000
    011001101000
    000000111010
    010001100000
    000011001101
    111100011111
    100010111011
    000010100111
    100101000001
    011001001010
    100101010001
    101001001101
    010011101001
    000001000101
    000010011000
    111011100001
    001100111010
    010011011000
    000001011101
    010100111001
    001010110000
    011011101000
    010010111011
    100101100100
    010111000011
    001001111001
    011111011110
    011110111011
    101010010111
    101101111011
    001100011101
    011011010010
    000011000100
    010010110010
    001111011110
    011100011001
    011011101111
    010110101010
    111011010000
    111111010110
    001100110110
    010000110111
    000011110100
    011011000001
    101100101110
    100011001110
    011000010100
    000110001011
    011000000001
    000000111100
    101100110101
    111110010011
    111110101001
    110110101111
    101110110101
    110101111001
    000010001101
    111010101000
    010010100101
    001111101111
    100110100110
    000001010000
    000011110101
    110100111000
    101010111100
    000000010100
    010100010101
    010001100010
    100011010010
    011101001001
    000010101111
    000101000101
    001001101100
    111111100101
    100111111010
    110011101011
    000011100000
    111111011100
    010100001010
    000011100110
    110011111101
    001100000000
    011010101111
    101010101011
    111011000111
    010100110010
    011110110101
    010000011001
    100011010110
    000000001110
    000010101101
    111110100011
    111110010000
    101011101010
    011011001101
    101011111111
    100101101011
    111001000100
    010010000101
    011001010101
    110001100010
    010100001101
    111111101101
    101101000111
    001110110101
    001101000101
    001000100110
    000011011000
    101001001001
    010001001000
    110110111010
    111110011100
    000111111100
    000110101111
    000001110001
    011101101010
    100001001101
    010100010011
    001001001110
    111110110101
    001110001011
    111010101110
    100111000000
    110100000010
    000010111110
    100100000100
    111111001000
    111010001000
    101011100111
    001111111100
    001001101110
    011000001111
    001001100001
    001110000110
    111011011011
    001010101111
    101110110110
    110010000110
    001100010100
    110100111001
    111111110110
    100011001011
    111111000101
    000111010010
    010100100110
    101010110110
    011110110100
    110110101100
    100100111111
    101101110100
    010110101110
    101001101101
    001101010011
    001000100101
    010111010011
    000011110011
    010011111111
    101000000110
    010001111110
    100111010010
    010100010100
    110100001111
    001100000001
    010010110110
    011010011011
    101000010001
    101100010110
    111010011000
    001001101111
    111101010001
    010101111111
    000111010110
    010111100100
    000111101111
    110010100001
    100101111100
    010010010011
    100100001000
    010110000001
    000011000110
    101100110100
    000001100101
    010110101000
    101010100010
    101001110000
    101111000001
    110001111110
    101011010101
    111000010001
    010000101101
    000101010011
    101100011100
    010101000000
    010001110010
    111000001010
    101001011100
    001101111101
    111000101011
    100100000000
    010001011111
    000101000011
    111000011000
    000000100101
    110100001010
    011111111101
    100001010100
    110000011000
    011110011100
    000000110110
    101100100101
    000110001110
    110101110100
    010011111011
    101011100110
    110110010101
    001110011100
    110101110000
    111001001111
    000010101011
    010011100001
    100101010111
    000111100101
    000011001110
    111001000111
    011001100100
    001110001101
    110101010100
    100101100111
    011001000000
    100000110100
    100011101101
    100100110101
    011000110110
    101110011011
    110101100001
    """

// MARK: Part 1

let (challengeGamma, challengeEpsilon) = gammaEpsilon(from: challengeInput)

if let challengeGammaInt = Int(challengeGamma, radix: 2), let challengeEpsilonInt = Int(challengeEpsilon, radix: 2) {
    challengeGammaInt * challengeEpsilonInt // 3901196 (correct)
}

// MARK: Part 2

func mostCommonBit(in input: [String], at position: Int) -> Character {
    var zeroCount = 0
    var oneCount = 0
    
    for string in input {
        let number = string[String.Index(encodedOffset: position)]
        
        if number == "0" {
            zeroCount += 1
        } else if number == "1" {
            oneCount += 1
        } else {
            print("Found unexpected number: \(number)")
        }
    }
    
    if zeroCount == oneCount {
        return "2"
    } else if zeroCount > oneCount {
        return "0"
    } else {
        return "1"
    }
}

func leastCommonBit(in input: [String], at position: Int) -> Character {
    var zeroCount = 0
    var oneCount = 0
    
    for string in input {
        let number = string[String.Index(encodedOffset: position)]
        
        if number == "0" {
            zeroCount += 1
        } else if number == "1" {
            oneCount += 1
        } else {
            print("Found unexpected number: \(number)")
        }
    }
    
    if zeroCount == oneCount {
        return "2"
    } else if zeroCount > oneCount {
        return "1"
    } else {
        return "0"
    }
}

func filtered(array: [String], for character: Character, at position: Int) -> [String] {
    array.filter { string in
        string[String.Index(encodedOffset: position)] == character
    }
}

func part2(_ input: String) -> Int? {
    
    let components = input.components(separatedBy: .newlines)
    
    var oxygenComponents = components
    var oxygenIndex = 0
    
    while oxygenComponents.count > 1 {
        var mostCommonBit = mostCommonBit(in: oxygenComponents, at: oxygenIndex)
        
        if mostCommonBit == "2" {
            mostCommonBit = "1"
        }
        
        oxygenComponents = filtered(array: oxygenComponents, for: mostCommonBit, at: oxygenIndex)
        
        oxygenIndex += 1
    }
    
    oxygenComponents
    
    var co2Components = components
    var co2Index = 0
    
    while co2Components.count > 1 {
        var leastCommonBit = leastCommonBit(in: co2Components, at: co2Index)
        
        if leastCommonBit == "2" {
            leastCommonBit = "0"
        }
        
        co2Components = filtered(array: co2Components, for: leastCommonBit, at: co2Index)
        
        co2Index += 1
    }
    
    if let oxygenString = oxygenComponents.first, let co2String = co2Components.first, let oxygenInt = Int(oxygenString, radix: 2), let co2Int = Int(co2String, radix: 2) {
        return oxygenInt * co2Int // 230 (correct)
    }
    
    return nil
}

part2(exampleInput) // 230 (correct)
part2(challengeInput) // 4412188 (correct)

