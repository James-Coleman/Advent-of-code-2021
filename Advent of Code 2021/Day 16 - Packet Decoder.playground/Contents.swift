import Foundation

var greeting = "Hello, playground"

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

enum Packet {
    case literal(LiteralPacket)
    case `operator`(OperatorPacket)
    
    init(string: String) throws {
        guard let int = Int(string, radix: 16) else { throw PacketError.stringIsNotValidHexadecimal(string) }
        
        var binaryString = String(int, radix: 2)
        binaryString.pad(with: "0", untilDivisibleBy: 4)
        
        let versionBinary = binaryString.poppingFirst(3)
        let versionInt = Int(versionBinary, radix: 2)!
        
        let typeIDBinary = binaryString.poppingFirst(3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        if typeIDInt == 4 {
            let (packet, _) = LiteralPacket.factory(version: versionInt, remainingString: binaryString)
            self = .literal(packet)
        } else {
            let (packet, _) = OperatorPacket.factory(version: versionInt, typeID: typeIDInt, remainingString: binaryString)
            self = .operator(packet)
        }
    }
    
    /// A way to provide an input string, then return the remaining string to create other.
    static func factory(from binaryString: String) -> (Packet, String) {
        var binaryString = binaryString
        
        let versionBinary = binaryString.poppingFirst(3)
        let versionInt = Int(versionBinary, radix: 2)!
        
        let typeIDBinary = binaryString.poppingFirst(3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        if typeIDInt == 4 {
            let (newPacket, remainingString) = LiteralPacket.factory(version: versionInt, remainingString: binaryString)
            return (.literal(newPacket), remainingString)
        } else {
            let (newPacket, remainingString) = OperatorPacket.factory(version: versionInt, typeID: typeIDInt, remainingString: binaryString)
            return (.operator(newPacket), remainingString)
        }
    }
}

struct LiteralPacket {
    let version: Int
    let literalValue: Int
    
    static func factory(version: Int, remainingString binaryString: String) -> (LiteralPacket, String) {
        var binaryString = binaryString
        
        var literalValueString = ""
        
        var continueDigit = "1"
        
        while continueDigit == "1" {
            var fiveBits = binaryString.poppingFirst(5)
            
            continueDigit = fiveBits.poppingFirst(1)
            
            literalValueString += fiveBits
        }
        
        let literalValueInt = Int(literalValueString, radix: 2)!
        
        let newPacket = LiteralPacket(version: version, literalValue: literalValueInt)
        
        return (newPacket, binaryString)
    }
}

do {
    let test = try Packet(string: "D2FE28")
    print(test)
} catch {
    error
}

struct OperatorPacket {
    let version: Int
    let typeID: Int
    let subPackets: [Packet]
    
    static func factory(version: Int, typeID: Int, remainingString binaryString: String) -> (OperatorPacket, String) {
        var binaryString = binaryString
        
        let lengthTypeID = binaryString.poppingFirst(1)
        
        var subPackets = [Packet]()
        
        if lengthTypeID == "0" {
            // Next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
            let numberBinary = binaryString.poppingFirst(15)
            let number = Int(numberBinary, radix: 2)!
            
            let startingCount = binaryString.count
            var subtractedCharacters = 0
            
            while subtractedCharacters < number {
                let (nextSubPacket, remainingString) = Packet.factory(from: binaryString)
                
                subPackets += [nextSubPacket]
                
                subtractedCharacters = startingCount - remainingString.count
                
                binaryString = remainingString
            }
        } else {
            // Next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
            let numberBinary = binaryString.poppingFirst(11)
            let number = Int(numberBinary, radix: 2)!
            
            while subPackets.count < number {
                let (nextSubPacket, remainingString) = Packet.factory(from: binaryString)
                
                subPackets += [nextSubPacket]
                binaryString = remainingString
            }
        }
        
        let newPacket = OperatorPacket(version: version, typeID: typeID, subPackets: subPackets)
        
        return (newPacket, binaryString)
    }
}

do {
    let test = try Packet(string: "38006F45291200")
    print(test)
} catch {
    error
}
