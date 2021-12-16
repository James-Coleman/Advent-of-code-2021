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

extension String {
    mutating func pad(with padding: String, untilDivisibleBy mod: Int) {
        var newString = self
        
        while newString.count % mod != 0 {
            newString = padding + newString
        }
        
        self = newString
    }
    
    mutating func poppingFirst(_ count: Int) -> String {
        guard let splitIndex = index(startIndex, offsetBy: count, limitedBy: endIndex) else { return self }
        
        let popped = self[..<splitIndex]
        
        self = String(self[splitIndex...])
        
        return String(popped)
    }
}

enum PacketError: Error {
    case stringIsNotValidHexadecimal(String)
}

struct LiteralPacket {
    
    let version: Int
    let typeID: Int // Might not need this because the packet type ID for a literal packet will always be 4
    let literalValue: Int
    
    init(string: String) throws {
        guard let int = Int(string, radix: 16) else { throw PacketError.stringIsNotValidHexadecimal(string) }
        
        var binaryString = String(int, radix: 2)
        binaryString.pad(with: "0", untilDivisibleBy: 4)
        
        let versionBinary = binaryString.poppingFirst(3)
        let versionInt = Int(versionBinary, radix: 2)!

        let typeIDBinary = binaryString.poppingFirst(3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        var literalValueString = ""
        
        var continueDigit = "1"
        
        while continueDigit == "1" {
            var fiveBits = binaryString.poppingFirst(5)
            
            continueDigit = fiveBits.poppingFirst(1)
            
            literalValueString += fiveBits
        }
        
        let literalValueInt = Int(literalValueString, radix: 2)!
        
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

struct OperatorPacket {
    let version: Int
    let typeID: Int
    let lengthTypeID: String
    let subpacketLength: Int
    
    init(string: String) throws {
        guard let int = Int(string, radix: 16) else { throw PacketError.stringIsNotValidHexadecimal(string) }
        
        var binaryString = String(int, radix: 2)
        binaryString.pad(with: "0", untilDivisibleBy: 4)
        
        let versionBinary = binaryString.poppingFirst(3)
        let versionInt = Int(versionBinary, radix: 2)!
        
        let typeIDBinary = binaryString.poppingFirst(3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        let lengthTypeIDBinary = binaryString.poppingFirst(1)
        let lengthLength = lengthTypeIDBinary == "0" ? 15 : 11
        
        let subPacketLengthBinary = binaryString.poppingFirst(lengthLength)
        let subPacketLengthInt = Int(subPacketLengthBinary, radix: 2)!
        
        version = versionInt
        typeID = typeIDInt
        lengthTypeID = lengthTypeIDBinary
        subpacketLength = subPacketLengthInt
    }
}

do {
    let test = try OperatorPacket(string: "38006F45291200")
    print(test)
} catch {
    error
}
