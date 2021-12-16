import Foundation

var greeting = "Hello, playground"

enum PacketError: Error {
    case stringIsNotValidHexadecimal(String)
}

extension String {
    mutating func pad(with padding: String, untilDivisibleBy mod: Int) {
        while count % mod != 0 {
            self = padding + self
        }
    }
    
    func binaryArray() throws -> [Character] {
        try map { character -> [Character] in
            guard let int = Int(String(character), radix: 16) else { throw PacketError.stringIsNotValidHexadecimal(self) }
            
            var binary = String(int, radix: 2)
            binary.pad(with: "0", untilDivisibleBy: 4)
            
            return binary.map { $0 }
        }.reduce([]) { soFar, next in
            var soFar = soFar
            
            for character in next {
                soFar += [character]
            }
            
            return soFar
        }
    }
}

extension Array where Element == Character {
    mutating func pad(with character: Character, untilDivisibleBy mod: Int) {
        while count % mod != 0 {
            insert(character, at: 0)
        }
    }
    
    mutating func popping(first count: Int) -> String {
        let characters = prefix(count)
        
        removeFirst(count)
        
        return characters.reduce("") { soFar, character in
            "\(soFar)\(character)"
        }
    }
}

do {
    var test = try "8A004A801A8002F478".binaryArray()
    test.count % 4
    test.pad(with: "0", untilDivisibleBy: 4)
    
//    test.prefix(3)
//    test.removeFirst(3)
    
    test.popping(first: 3)
    test
} catch {
    error
}

enum Packet {
    case literal(LiteralPacket)
    case `operator`(OperatorPacket)
    
    var versionSum: Int {
        switch self {
            case let .literal(literal):
                return literal.version
            case let .operator(`operator`):
                return `operator`.versionSum
        }
    }
    
    var value: Int? {
        switch self {
            case let .literal(literal):
                return literal.literalValue
            case let .operator(`operator`):
                return `operator`.value
        }
    }
    
    /// `string` must be valid Hexadecimal
    init(string: String) throws {
        var binaryArray = try string.binaryArray()
        binaryArray.pad(with: "0", untilDivisibleBy: 4)
        
        let versionBinary = binaryArray.popping(first: 3)
        let versionInt = Int(versionBinary, radix: 2)!
        
        let typeIDBinary = binaryArray.popping(first: 3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        if typeIDInt == 4 {
            let (packet, _) = LiteralPacket.factory(version: versionInt, remaining: binaryArray)
            self = .literal(packet)
        } else {
            let (packet, _) = OperatorPacket.factory(version: versionInt, typeID: typeIDInt, remaining: binaryArray)
            self = .operator(packet)
        }
    }
    
    /// A way to provide an input string, then return the remaining string to create other.
    static func factory(from binaryArray: [Character]) -> (Packet, [Character]) {
        var binaryArray = binaryArray
        
        let versionBinary = binaryArray.popping(first: 3)
        let versionInt = Int(versionBinary, radix: 2)!
        
        let typeIDBinary = binaryArray.popping(first: 3)
        let typeIDInt = Int(typeIDBinary, radix: 2)!
        
        if typeIDInt == 4 {
            let (newPacket, remainingArray) = LiteralPacket.factory(version: versionInt, remaining: binaryArray)
            return (.literal(newPacket), remainingArray)
        } else {
            let (newPacket, remaining) = OperatorPacket.factory(version: versionInt, typeID: typeIDInt, remaining: binaryArray)
            return (.operator(newPacket), remaining)
        }
    }
}

struct LiteralPacket {
    let version: Int
    let literalValue: Int
    
    static func factory(version: Int, remaining binaryArray: [Character]) -> (LiteralPacket, [Character]) {
        var binaryArray = binaryArray
        
        var literalValueString = ""
        
        var continueDigit = "1"
        
        while continueDigit == "1" {
            continueDigit = binaryArray.popping(first: 1)
            
            literalValueString += binaryArray.popping(first: 4)
        }
        
        let literalValueInt = Int(literalValueString, radix: 2)!
        
        let newPacket = LiteralPacket(version: version, literalValue: literalValueInt)
        
        return (newPacket, binaryArray)
    }
}

struct OperatorPacket {
    let version: Int
    let typeID: Int
    let subPackets: [Packet]
    
    var versionSum: Int {
        version + subPackets.reduce(0) { soFar, packet in
            switch packet {
                case let .literal(literal):
                    return soFar + literal.version
                case let .operator(`operator`):
                    return soFar + `operator`.versionSum
            }
        }
    }
    
    var value: Int? {
        switch typeID {
            case 0:
                // Sum
                return subPackets.reduce(0) { $0 + ($1.value ?? 0) }
            case 1:
                // Product
                return subPackets.reduce(1) { $0 * ($1.value ?? 1) }
            case 2:
                // Minimum
                return subPackets.compactMap { $0.value }.sorted(by: <).first
            case 3:
                // Maximum
                return subPackets.compactMap { $0.value }.sorted(by: >).first
            case 5:
                // Greater than
                if let value0 = subPackets[0].value, let value1 = subPackets[1].value, value0 > value1 {
                    return 1
                } else {
                    return 0
                }
            case 6:
                // Less than
                if let value0 = subPackets[0].value, let value1 = subPackets[1].value, value0 < value1 {
                    return 1
                } else {
                    return 0
                }
            case 7:
                // Equal 1
                if let value0 = subPackets[0].value, let value1 = subPackets[1].value, value0 == value1 {
                    return 1
                } else {
                    return 0
                }
            default:
                return nil
        }
    }
    
    static func factory(version: Int, typeID: Int, remaining binaryArray: [Character]) -> (OperatorPacket, [Character]) {
        var binaryArray = binaryArray
        
        let lengthTypeID = binaryArray.popping(first: 1)
        
        var subPackets = [Packet]()
        
        if lengthTypeID == "0" {
            // Next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
            let numberBinary = binaryArray.popping(first: 15)
            let number = Int(numberBinary, radix: 2)!
            
            let startingCount = binaryArray.count
            var subtractedCharacters = 0
            
            while subtractedCharacters < number {
                let (nextSubPacket, remainingString) = Packet.factory(from: binaryArray)
                
                subPackets += [nextSubPacket]
                
                subtractedCharacters = startingCount - remainingString.count
                
                binaryArray = remainingString
            }
        } else {
            // Next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
            let numberBinary = binaryArray.popping(first: 11)
            let number = Int(numberBinary, radix: 2)!
            
            while subPackets.count < number {
                let (nextSubPacket, remainingString) = Packet.factory(from: binaryArray)
                
                subPackets += [nextSubPacket]
                binaryArray = remainingString
            }
        }
        
        let newPacket = OperatorPacket(version: version, typeID: typeID, subPackets: subPackets)
        
        return (newPacket, binaryArray)
    }
}

do {
    let example1 = try Packet(string: "D2FE28")
    print(example1)
    
    let example2 = try Packet(string: "38006F45291200")
    print(example2)
    
    let example3 = try Packet(string: "EE00D40C823060")
    print(example3)
    
    let example4 = try Packet(string: "8A004A801A8002F478")
    print(example4)
    example4.versionSum // 16 (correct)
    
    let example5 = try Packet(string: "620080001611562C8802118E34")
    example5.versionSum // 12 (correct)

    let example6 = try Packet(string: "C0015000016115A2E0802F182340")
    example6.versionSum // 23 (correct)
    
    let example7 = try Packet(string: "A0016C880162017C3686B18A3D4780")
    example7.versionSum // 31 (correct)
    
//    let puzzle1 = try Packet(string: "020D78804D397973DB5B934D9280CC9F43080286957D9F60923592619D3230047C0109763976295356007365B37539ADE687F333EA8469200B666F5DC84E80232FC2C91B8490041332EB4006C4759775933530052C0119FAA7CB6ED57B9BBFBDC153004B0024299B490E537AFE3DA069EC507800370980F96F924A4F1E0495F691259198031C95AEF587B85B254F49C27AA2640082490F4B0F9802B2CFDA0094D5FB5D626E32B16D300565398DC6AFF600A080371BA12C1900042A37C398490F67BDDB131802928F5A009080351DA1FC441006A3C46C82020084FC1BE07CEA298029A008CCF08E5ED4689FD73BAA4510C009981C20056E2E4FAACA36000A10600D45A8750CC8010989716A299002171E634439200B47001009C749C7591BD7D0431002A4A73029866200F1277D7D8570043123A976AD72FFBD9CC80501A00AE677F5A43D8DB54D5FDECB7C8DEB0C77F8683005FC0109FCE7C89252E72693370545007A29C5B832E017CFF3E6B262126E7298FA1CC4A072E0054F5FBECC06671FE7D2C802359B56A0040245924585400F40313580B9B10031C00A500354009100300081D50028C00C1002C005BA300204008200FB50033F70028001FE60053A7E93957E1D09940209B7195A56BCC75AE7F18D46E273882402CCD006A600084C1D8ED0E8401D8A90BE12CCF2F4C4ADA602013BC401B8C11360880021B1361E4511007609C7B8CA8002DC32200F3AC01698EE2FF8A2C95B42F2DBAEB48A401BC5802737F8460C537F8460CF3D953100625C5A7D766E9CB7A39D8820082F29A9C9C244D6529C589F8C693EA5CD0218043382126492AD732924022CE006AE200DC248471D00010986D17A3547F200CA340149EDC4F67B71399BAEF2A64024B78028200FC778311CC40188AF0DA194CF743CC014E4D5A5AFBB4A4F30C9AC435004E662BB3EF0")
//    puzzle1.versionSum // 901 (correct)
    
    let example8 = try Packet(string: "C200B40A82")
    example8.value // 3 (correct)
    
    let example9 = try Packet(string: "04005AC33890")
    example9.value // 54 (correct)
    
    let example10 = try Packet(string: "880086C3E88112")
    example10.value // 7 (correct)
    
    let example11 = try Packet(string: "CE00C43D881120")
    example11.value // 9 (correct)
    
    let example12 = try Packet(string: "D8005AC2A8F0")
    example12.value // 1 (correct)
    
    let example13 = try Packet(string: "F600BC2D8F")
    example13.value // 0 (correct)
    
    let example14 = try Packet(string: "9C005AC2F8F0")
    example14.value // 0 (correct)
    
    let example15 = try Packet(string: "9C0141080250320F1802104A08")
    example15.value // 1 (correct)
} catch {
    error
}
