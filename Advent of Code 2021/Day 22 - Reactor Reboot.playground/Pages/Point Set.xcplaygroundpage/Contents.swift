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

struct PointCloud: Hashable {
    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>
}

let xs = -57795 - -6158
let ys = 72030 - 29564
let zs = 90618 - 20435

xs * ys * zs // 153_898_464_422_086
