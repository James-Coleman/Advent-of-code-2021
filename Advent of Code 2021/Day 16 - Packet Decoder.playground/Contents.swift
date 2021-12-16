import Foundation

var greeting = "Hello, playground"

Int("0000", radix: 2)
Int("0001", radix: 2)
Int("0010", radix: 2)
Int("0011", radix: 2)
Int("0100", radix: 2)
Int("0101", radix: 2)
Int("0110", radix: 2)
Int("0111", radix: 2)
Int("1000", radix: 2)
Int("1001", radix: 2)
Int("1010", radix: 2)
Int("1011", radix: 2)
Int("1100", radix: 2)
Int("1101", radix: 2)
Int("1110", radix: 2)
Int("1111", radix: 2)

Int("011111100101", radix: 2)

Int("D2FE28", radix: 16) // 13827624
String(13827624, radix: 2) // "110100101111111000101000"

struct LiteralPacket {
    enum Error: Swift.Error {
        case stringIsNotValidHexadecimal(String)
        case versionBinaryNotInt(Substring)
        case typeIDBinaryNotInt(Substring)
        case literalValueBinaryNotInt(String)
        case noContinueDigit
    }
    
    let version: Int
    let typeID: Int // Might not need this because the packet type ID for a literal packet will always be 4
    let literalValue: Int
    
    init(string: String) throws {
        guard let int = Int(string, radix: 16) else { throw Error.stringIsNotValidHexadecimal(string) }
        
        let binaryString = String(int, radix: 2)
        
//        let versionSlice = string[...2]
        let startIndex = binaryString.startIndex
        let versionEndIndex = binaryString.index(startIndex, offsetBy: 2)
        let versionBinary = binaryString[...versionEndIndex]
//        print(versionBinary)
        guard let versionInt = Int(versionBinary, radix: 2) else { throw Error.versionBinaryNotInt(versionBinary) }
        
        let typeIDStartIndex = binaryString.index(versionEndIndex, offsetBy: 1)
        let typeIDEndIndex = binaryString.index(typeIDStartIndex, offsetBy: 2)
        
        let typeIDBinary = binaryString[typeIDStartIndex...typeIDEndIndex]
        
//        print(typeIDBinary)
        
        guard let typeIDInt = Int(typeIDBinary, radix: 2) else { throw Error.typeIDBinaryNotInt(typeIDBinary) }
        
        var literalValueString = ""
        
        var digitsStartIndex = binaryString.index(typeIDEndIndex, offsetBy: 1)
        
        var digitsEndIndex = binaryString.index(digitsStartIndex, offsetBy: 4)
        
        var continueDigit: Character = "1"
        
        while continueDigit == "1" {
            var fiveBits = binaryString[digitsStartIndex...digitsEndIndex]
//            print(fiveBits)
            
            guard let continueDigitLocal = fiveBits.popFirst() else { throw Error.noContinueDigit }
            
//            print(continueDigitLocal)
            
            continueDigit = continueDigitLocal
            
//            print(fiveBits)
            
            literalValueString += fiveBits
            
            guard
                let nextStartIndex = binaryString.index(digitsStartIndex, offsetBy: 5, limitedBy: binaryString.endIndex),
                let nextEndIndex = binaryString.index(digitsEndIndex, offsetBy: 5, limitedBy: binaryString.endIndex)
            else { break }
            
            digitsStartIndex = nextStartIndex
            digitsEndIndex = nextEndIndex
        }
        
//        print(literalValueString)
        
        guard let literalValueInt = Int(literalValueString, radix: 2) else { throw Error.literalValueBinaryNotInt(literalValueString) }
        
        version = versionInt
        typeID = typeIDInt
        literalValue = literalValueInt
    }
}

do {
    let test = try LiteralPacket(string: "D2FE28")
    print(test)
} catch {
    error
}

//func decode(string: String) ->
