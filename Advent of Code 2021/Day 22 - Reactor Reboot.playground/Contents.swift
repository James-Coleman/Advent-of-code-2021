import Foundation

var greeting = "Hello, playground"

typealias ReactorInstruction = (on: Bool, x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>)

func parse(rangeString: String) -> ReactorInstruction {
    let boolRange = rangeString.components(separatedBy: " ")
    
    let onOff = boolRange[0]
    let onBool = onOff == "on"
    
    let ranges = boolRange[1].components(separatedBy: ",")
    
    let xRangeString = ranges[0]
    let xRange = xRangeString
        .components(separatedBy: "=")
        .flatMap { $0.components(separatedBy: "." ) }
        .compactMap { Int($0) }

    let yRangeString = ranges[1]
    let yRange = yRangeString
        .components(separatedBy: "=")
        .flatMap { $0.components(separatedBy: "." ) }
        .compactMap { Int($0) }
    
    let zRangeString = ranges[2]
    let zRange = zRangeString
        .components(separatedBy: "=")
        .flatMap { $0.components(separatedBy: "." ) }
        .compactMap { Int($0) }


    return (onBool, xRange[0]...xRange[1], yRange[0]...yRange[1], zRange[0]...zRange[1])
}

parse(rangeString: "on x=10..12,y=10..12,z=10..12")

func parse(input: String) -> [ReactorInstruction] {
    input.components(separatedBy: .newlines).map { parse(rangeString: $0) }
}

let exampleInput1 = """
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10
"""

let exampleParsed = parse(input: exampleInput1)

var testDictionary = [Int: [Int: [Int: Bool]]]()

func set(value: Bool?, x: Int, y: Int, z: Int, in dict: inout [Int: [Int: [Int: Bool]]]) {
    if dict[x] == nil {
        dict[x] = [:]
    }
    if dict[x]?[y] == nil {
        dict[x]?[y] = [:]
    }
    
    dict[x]?[y]?[z] = value
    
    if dict[x]?[y]?.isEmpty ?? false {
        dict[x]?[y] = nil
    }
    if dict[x]?.isEmpty ?? false {
        dict[x] = nil
    }
}

set(value: true, x: 10, y: 10, z: 10, in: &testDictionary)
set(value: true, x: 10, y: 10, z: 11, in: &testDictionary)
set(value: true, x: 11, y: 10, z: 12, in: &testDictionary)
set(value: false, x: 10, y: 10, z: 10, in: &testDictionary)
set(value: nil, x: 11, y: 10, z: 12, in: &testDictionary)

typealias Reactor = [Int: [Int: [Int: Bool]]]

var exampleDictionary = Reactor()

for line in exampleParsed {
    for x in line.x {
        for y in line.y {
            for z in line.z {
                set(value: line.on ? true : nil, x: x, y: y, z: z, in: &exampleDictionary)
            }
        }
    }
}

func cubeOnCount(_ reactor: Reactor) -> Int {
    reactor.reduce(0) { xPartial, yDict in
        xPartial + yDict.value.reduce(0) { yPartial, zDict in
            yPartial + zDict.value.reduce(0) { zPartial, keyValue in
                zPartial + (keyValue.value ? 1 : 0)
            }
        }
    }
}

cubeOnCount(exampleDictionary)

func reactor(from instructions: [ReactorInstruction]) -> Reactor {
    var reactor = Reactor()

    for line in instructions {
        for x in line.x {
            for y in line.y {
                for z in line.z {
                    set(value: line.on ? true : nil, x: x, y: y, z: z, in: &reactor)
                }
            }
        }
    }

    return reactor
}

let exampleLarger = """
on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
"""

//let exampleLargerParsed = parse(input: exampleLarger)
//let exampleLargerReactor = reactor(from: exampleLargerParsed)
//let exampleLargerCount = cubeOnCount(exampleLargerReactor)

2758514936282235
Int.max

let xs = -57795 - -6158
let ys = 72030 - 29564
let zs = 90618 - 20435

xs * ys * zs
