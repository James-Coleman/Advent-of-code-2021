//
//  Day 25.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 25/12/2021.
//

import Foundation

func day25() {
    enum SeaCucumber {
        case east
        case south
    }

    struct OceanFloor {
        let widthIndex: Int
        let heightIndex: Int
        var cucumbers: [Int: [Int: SeaCucumber]]
        
        init(_ input: String) {
            let lines = input.components(separatedBy: .newlines)
            
            guard let firstLine = lines.first else {
                self.widthIndex = 0
                self.heightIndex = 0
                self.cucumbers = [:]
                return
            }
            
            self.widthIndex = firstLine.count - 1
            self.heightIndex = lines.count - 1
            
            let dicts: [Int: [Int: SeaCucumber]] = lines.enumerated().reduce([:]) { lineSoFar, line in
                let (lineIndex, line) = line
                
                let dict: [Int: SeaCucumber] = line.enumerated().reduce([:]) { soFar, next  in
                    let (index, character) = next
                    
                    var soFar = soFar
                    
                    if character == ">" {
                        soFar[index] = .east
                    } else if character == "v" {
                        soFar[index] = .south
                    }
                    
                    return soFar
                }
                
                var lineSoFar = lineSoFar
                
                lineSoFar[lineIndex] = dict
                
                return lineSoFar
            }
            
            self.cucumbers = dicts
        }
        
        /**
         - returns: `true` if something could and did step, otherwise `false`.
         */
        mutating func step() -> Bool {
            let eastShouldStep: [(new: (x: Int, y: Int), old: (x: Int, y: Int))] = cucumbers.flatMap { yIndex, dict -> [(new: (x: Int, y: Int), old: (x: Int, y: Int))] in
                dict.compactMap { xIndex, point -> (new: (x: Int, y: Int), old: (x: Int, y: Int))? in
                    guard point == .east else { return nil }
                    
                    if xIndex == widthIndex {
                        // On eastern edge, check western edge
                        if cucumbers[yIndex]?[0] == nil {
                            return (new: (x: 0, y: yIndex), old: (x: xIndex, y: yIndex))
                        }
                    } else {
                        if cucumbers[yIndex]?[xIndex + 1] == nil {
                            return (new: (x: xIndex + 1, y: yIndex), old: (x: xIndex, y: yIndex))
                        }
                    }
                    
                    return nil
                }
            }
            
            eastShouldStep.forEach { point in
                cucumbers[point.new.y]?[point.new.x] = .east
                cucumbers[point.old.y]?[point.old.x] = nil
            }
            
            let southShouldStep: [(new: (x: Int, y: Int), old: (x: Int, y: Int))] = cucumbers.flatMap { yIndex, dict -> [(new: (x: Int, y: Int), old: (x: Int, y: Int))] in
                dict.compactMap { xIndex, point -> (new: (x: Int, y: Int), old: (x: Int, y: Int))? in
                    guard point == .south else { return nil }
                    
                    if yIndex == heightIndex {
                        // On southern edge, check northern edge
                        if cucumbers[0]?[xIndex] == nil {
                            return (new: (x: xIndex, y: 0), old: (x: xIndex, y: yIndex))
                        }
                    } else {
                        if cucumbers[yIndex + 1]?[xIndex] == nil {
                            return (new: (x: xIndex, y: yIndex + 1), old: (x: xIndex, y: yIndex))
                        }
                    }
                    
                    return nil
                }
            }
            
            southShouldStep.forEach { point in
                cucumbers[point.new.y]?[point.new.x] = .south
                cucumbers[point.old.y]?[point.old.x] = nil
            }
            
            return eastShouldStep.isEmpty == false || southShouldStep.isEmpty == false
        }
        
        /**
         - returns: The number of steps required before the cucumbers are locked and cannot move (+1).
          +1 because it must be the first step on which there is no movement.
         */
        mutating func settle() -> Int {
            var numberOfSteps = 0
            
            var cucumbersCanMove: Bool
            
            repeat {
                cucumbersCanMove = step()
                numberOfSteps += 1
            } while cucumbersCanMove
            
            return numberOfSteps
        }
        
        func debugPrint() {
            var stringToPrint = ""
            
            for y in 0...heightIndex {
                for x in 0...widthIndex {
                    let cucumber = cucumbers[y]?[x]
                    
                    switch cucumber {
                        case .some(.east):
                            stringToPrint += ">"
                        case .some(.south):
                            stringToPrint += "v"
                        case .none:
                            stringToPrint += "."
                    }
                }
                stringToPrint += "\n"
            }
            
            print(stringToPrint)
        }
    }
    
    let puzzleInput = """
    v>.>>v>.v>.v.>...>>>.>>v..v>v>vv.>>>.>>..vv>>>.>>.v..v..>....v....>.v>...>..v..v.>..>>.>..v.vvv...>>>>>.v...>>>>>.>v.v>>.v>..>..>.>>..>>>>>
    ..v>v.vvv....vv.vv.v..v..>>>>...v...>..>>......v>.>.vvv.>v..>..v>...>>.......v>>.>v>.v.>>.>>v..v.v.>>>v...>v....>.>.>...v.>..>.v.v>v>v..v.v
    >vv...v.>.>.>v.vv>.>.vvv>..v...v.v.>...>.v>..v.v...vv>>.>v.>.>>....>>...>.vv...v>.v..>>..v.>vv...>v...>>...v..v.v..v>.v>v...v.v..>..>.v>v>.
    ..v>>.vvv..>>v>>.v>.....>>>.v...v..v.>......>>........vv..>.v>v.>v.v>.vv.vv>..vv>.>..v.........vv..>vv...v.>..v>.>.>>>..v.>v.v.....v.>>v.v.
    .>.v>..v.vv>..vvvvv..v..v...>v.>v..>..>>..v>.v>....>..>>...>.vv.v>.v.v>>.v>vvvvv>>v>v..>...>..vvv..>v>.v>v.v>...vv.vvvv>.vvvv...v....>>v.>v
    .v.>v..v.>.v>v>....v..>>v.>vv>.>>v>..v>..v>v.v.vv>..>v>.>.v.v.vv.v>>.vv.>..v.vv>>v.>....>.>.>v.vv...>....>..>>v.>.v.>v....v>.v>....>>v>.v..
    >>..vvvv..>v..v..v>..>.>.>...>>.>>>v.>.>.>....vv...vv.....>..>v..v.v..>>>>vv....>v.>.v..>vv...v>v...>..v>....v.v.>....>.v.>.>...v.vvv>vv>..
    .v..v..v..v..>v.>>>>...>..>......>v.v>>>.>....vv....v>>v....>.vv.>>.>v..v..>.v...vv>vv.>>>.vv>>>.>.vv.v>v.>...>...>..v>v.>>v..>..>v.>....vv
    .>.v.>.vv.v.>...>...v.v>.v.>.>>v.vv>.....>.>vv..v..>v.>v>vv.>.>.vv...v.v>.....>.>v..v..>.>v.....>..>..>..>v..>.>.v.>v.vv...vv>v..v..>.v>...
    v...>>...vv....vv>.v.v.>>..vvv>>v...v.vv.v.v.v.>..v..>....v>vv>..>vvv>>..v>>>>.>.v...v>..>v.v.>..>v..>v>vvvvvv.v....v.>...>.v.v....vv>...v.
    v........>v.>..v..>...v.v>.>.v.v...vvv>...>..>v.vv.....>>.>>>..v.....v>..>.v.>v>vv>.>vv..v.v>.v....v>...v.>>>>...v.v>>..v...v.vv.vvv...v..>
    v>.>.v>v.v.v>>v.....>..v.v>.v.v.>..>v>vv...v.v.>>vvvvvv.v..vv......>v>v.vv>.>v.>..v>vvv.>>v.v>.>.>.v...v...v.>.vv..>.>vv.vv.>>>>>v.>v.....>
    v..v.>v>vvv..>.>..>.>>....v>.vvvvv..>..v..>>..v>..>>>vv..>>.v.>......v..v.v.>..>>v...vv>>.v..>..>v>v..v..v>.>.>.v.>...>>>...v........>.>v>v
    v.>v>.....vv..>vvv>>.>.v.>v.>v.vvv.>>>>.....>...v...>...v.....v..v.v....v>.>>v..v>.>.v..v.......>v...v.>..v..>.>.>>>...vvv>..v>>.vv>.v.>..v
    v..>.v.v..v...v.>.>.>.>.v...>.v>.v.v>...vv.>.v.....>....>....>v>......>.>..v..v.>...v.>..v...>>>.>>....>.v>.v>v>v>>.v>.v>v>..v.v.v..>>.....
    v>.v>.>>>>....v.>.v......>>v.>vv..v.>..>.....>.v>....>.v.vv>v>.>v.>.>>vvvv.vv.v>.>.......>...>>.v>vv.v..>v>...>.vv..vv>v>..vvv>...>......>v
    .>>v..>>..v..v..>...v.>v.>.>.v......>..>...>v.>.vv>...>vv>v..v..vvv.>v>..v..v>>.>>.v..>..>>>...vvv..vv.>.v.vvv>...v>>.v.>..>vvv>.v.v..v....
    v..>...v.vv>vv.>>v>>.>.v....vv>vv..v>.>.....vvv..>.>...vv.vvv.vvvv.v>.>...>..>v..>....>...v..vv>>v>>......v..>..>.>vv...v>...>..v.........v
    ..........v...>.....v..>..>>.>>.....>...>..>.vv>.>.vv..>v.v...>>.vvv...v..v>..>v>..>.>vv>>v...>.v.>.>>.v.....vvv>...v>vv.>vv>>.v>...>.>v..v
    ..>.vvv..>.vv..vv>vv.>...v>>.v..>.vv.>>v>v>v.v.>v>..>>.>.vv..v>.v....v.v.>v....vvv.vv.>v>..>.vv>.>.vv.>.>.>v..>>.v.v.>>.v....>.>>>v.>v.>.vv
    v>v.>>.>>.>.>.>.v>.v>..>.v>v>>>vv.>vv...>>.>>vv>...v.vvv..>.>v..v..v.vv>v.v..>...>.v.vv....>.......>.v..>....>..>v......v........>>vv.v.>..
    ....v.>vvv...>v..>...>v.v>>.vv.v..>>>..>v.>v.vv.>..>v>.....v.>>...>..v>>.v>>>.....>.v..>v.v...>v.v>>>>..v>>>v.v>v..v>vv..>..>v>..v.>v>v.>>v
    .>...>..>>>v.v...>v..>.v..vv..>....>....v..>vvv.>.v..v>v.v.>vv...v>v...v.>..v>v..v..vv>>vv.....>.v>>...vv...v...>.>vv.v>..>v>vv....v.....v.
    ...v>v>v>v.>..>..v.>..>..v..v....v..v..v>...v.>vv.>>v.>.>.v...vvv>...v>....>v...>>...v>v.>v....v>>..>v.v>.>v.v..>...>>...>>>..vv.>..v.>..>.
    .vv>.>v..>vvv..>.>>v.>.v.>.>>vv.>..v.v.vv>v.vvvvv>.v.>........v>vvvvv....vv>.v...v.>....>v......>>.>.>>v.>>..v.........>v.v.>....>....>>v.v
    >>.v.v.>v.v>.>.v>..>vv..v.>v.>>>..>.v>.>.>.v.>>>v>...>vv>.vv>...>>v.v>.v..v.....v.v........v.>.>>..vv.v>.v...vv>vvv>v...v...v>>vv.>.v..>>..
    vv.v>.v>v>>>>.........>.v>..v>....vv>.v>..v..v..>.v>.v..>>..>>..v.......vv>>>v.v..>..>>v>..v...>.v..vvv.>vv.vvvv>>.v.v...v.>...v.v>>v>.>vv>
    v......v...>.v>v....v..v.>..v>>.>.>vv.vv.vv>v.>.v>v>v>v>>..>vv>vv..v..v.>..>>.vv>v..>>v.v>v.vvv>.....>>..v>>v......>>>.>vv>.>vv...>>..vv...
    v..vv.>....v..v......>.v.v...>v.v.v.>..v>.>.v.v.>>>.>>>.>..>.v..v.v>..v.vv.v.>vv>>v>v.v>v....>v...>..v.v..v..>..>.v.>v.>>..>vv..vv..v>>>>v.
    v...>>v..vv>.vv...v.v>>>vv>v.v.....>...>v.v>..v.vv..>>>v..>>v.>vv>.v>...v.v.v....vv>>vv>....vv.>v.v.v.>..>..>.>v>..v>...vv>v.>v>>..>>>>.v.v
    ..v..v.v..v.v>...v>v.>>.>>>v>v...vv>....v...>v...>.>>....v>v...vvv.v>...>v.....>v...>v>..>>>v.>.>.........v>..>>>>>....v..v..v...v.vvvvv>>>
    .>v...v......>v.>v.v>v>...>v>.v>>.>.>..v..>v.>v>....>>v....v.v..v>..vvv.v>.v>...>.v>.vv.vv....v...vv>>.>.>..>.>....>..>>>v.>vv>.>>..>>...v.
    ..vv.>...>.v>.>>vvvv.v.v>>..>.>>v...>...v.....v.vvv.>>>vv...>...>..>.v.v.v....v.v.>..>vv>...vvvv..>v>>.>.vvv>..vv>>v....v>...>..v...v.vv...
    ..v...v...>>>..v..v.v>..v...>>.>v....>.v>>.>>v....vvv..vv.>>..>..vv.v.>>v>>>v...vv...>v..v.v.v.>.>v.>.v.vvv>v..v....vv..>...v..>vvv......v.
    >.v.>v>vv>....>..v>..>..v.>....>.v.>>v.v....v.>v...v>>...>v......v>>v....vv..v>...v.v>vvv.v.vv.>.>>..>..v.>.>>>.v>>..v>v>>v>>v>>>>.>..>v...
    vv....>>v>v...>v.>v>.vv>vvv>v..>.>.vvv.....>v..>...v.>>......v>.>>..>..vv.>v.>v..v..v...v>>v.>.....>....>vv.>>>>>>.>>>.v.v....v.v>v..v>v.vv
    >v.>.>.vv.vv>.>.v>v..v.>........v>>>...vv..vv...vv...>.>vvv>.v>v>vv>.>v>.>.v>v>>.>..v.v.>>>>>..v>>vv.>.>..vv>v..>>v.v>..>..>...>v>.>.vv>>..
    v..v..v..>......>>>v..>.v........vvv>v>v.>>v.v>....>..>.>>.v..v.>v.>v>v....v>v.>.v.>.>.>..vv>..>..v.v>..vv.v.>..v......v>>.v>....vv.>>>vv>.
    ....v..v.>vv>.>.v....vv>..v.>v..v..>.v.vv.>...>..>.v.v.vvvv.>v>..v>.>v.>>....v....>>>...v..v.v......>.>vv>.v>..vvv.>.>v>.>.>vv..>.vv.vv.v.>
    >......>vv.vv..vv..v.vv.>>>v..>v.>.v..v..>.>.>>.v>..>>...vv>>...>.v.v.v>.>vv.>.v.v>.>.>>>..>>...>v....v.vvv.vvv...>>>v>>v..vvv.>>>>v>...v>>
    .v>>.>.>v.>..v.>>.vv.v..>.....>.>v>vv..v.v....>v>..v>....>.vvv.>.>v....>vvvvv>>......>vvv...>.v.........>..v..v.>>vv...v.v......vvv.vv>.>v.
    >...>v>.>v.>..v.v>..v>v..v.v.....>v>..v...>..>v.v..v.>vv..>.>v.vv.>>>..>.>v>vv>>v.>..>>.v>.>v....v.>>>>v>>>>>v.v>>>...vvv..>....v..vvv....v
    .vv.>..>.....v.....>.v>v>.v.....>....vv.v..>>>vv..>.v......>vv>v.v>..v..>>>.vv>.vvv..>v>>.v..>..>..>>.....v>>....>..v.v>.v..vv.vv.v>v...v..
    .>v......>.>vv>..>.v.>.>v....v>...v..>..v>.>.v.v.v.v>>>v>.vv.>.v.v.>>>...>....>..>..>vv>>.>...v.>>.v>.v.v.v.>.....v.vv>..v>.vv.....>...v>v>
    ..v.>.v>v..>.>.>....v..>.v..>.v>.vv>>.>>..>>v>.v..>..>.>.v.>>.>v>v.vv..>..>..>>.>>.v.>>..v..>v.......v.>>..v>.>..v>.v>>..vv...>..v...v>>vvv
    .>..>.v..v.vv>>....v...>>v>>...v..v.>...>v..v...>.v>>......>.>v.>...v..v...>v.v>......v....>>.....>..v.>>.v.v.v.>.>>>...vv......v>...>.vv>.
    .v.>v.>.>..>v>..>.vv.>.v...>>.v.>....>>v>......>.>v.v.v.vv..>>v.v.>>.v.>v>>.v>.>...>..>.v>..>..v....>...vv.v.>>........v>>.......>>.vv>..v>
    .v>v.>v>..v..>v.>.vv.>v>>v>>....vv>....>>>>.>.>>v..>v...v>>......vv>v.>vv.vv..>.v.>...>>.>vv>.>..>.....v.v.v..vv....v>..vv>>v..>vv.....>vvv
    .v>v...vv.>v......>....v>>..v>.vv...vv>..>.>v>..>.>..vv>>...>vvv.>..>..vv.v...v.vv>v.>>>>v.....v.v>..v....>...>.v>.vv.vv.>>.>...v..>vv>.>>v
    .>.v>>v..v.v.v..v.>....>.v>v.v...vv.>.>v..>v>>v.v.v>.>v>.>v..>.>.>v.v>vv>>.....>v....v>>>vv.v>>..v.>.>>>...>vv>v.v..v>....vv>>.>>>.......vv
    .>.v>.vvv.v.vv....>..vvv.>..vv.v>..v>.>vvvvvv..vv..v.v>>...v...v.v....>>>>>>.>....vv>v.v.........>vvv.v>>>.v>.vv>>..v...>.v...>v>v>.v....v>
    >.v>v.v>...v.v.vv.>>>.vv.vv>.>....v>.vvvv.....v.>.....>....>..vv>v..v....v.v.>.>.v...v.vv>...>v.>>..v...vvv...v..v.....>vv....v>v.v...v>>vv
    v.>v........>....>v>v.v..v......>...v..v.>v.v..>.>vv>v...>>>.v>.>..>v>..v..>v...v>.v.>.v..>v>.....>>v.>.>v.v..v.......>.>.>...>v.v.v.v.vvv.
    .>...>....>...v>..v...v>v>>..v>>>.>.>>v>vv.>>vv>.>v..>.>.>>v>>vv.v.v..v..vv.v..>.>..v>vv...vv>..>...>v.vv>>...>.>..>..v>...v>>v>.v>...v....
    v>>vvv..v...v....>..>...v>.>vv....>..v...>>....v.>.>.>.v....vvv.vvvv>.>..>v>..>.....>vv.vvv.>>>...v.>.vv.v.v>>...vv>...v...v.vv.v.v.>>v..>.
    vv.vvv>.vv>..v..>v>..>..v...v>vv.>....v.....>.>...vv.>vv>.>>.vv..>v>>...>.>>>v.vv>......>.>.v>v>>..vv..vv.>>v>>....>.vvv>v>>...>>.>.>>.v>v.
    ...>vv.>..>..>..v.v.v>.vvv..>v>....>.v>>..>vvv.>v.v.>.v....vv.>....v>>>v>>.>v.>.>v>>.v..>v>....vv.vv>.v.>....v..>>v..>vv>.v.>>..>........v>
    >.>.>vv>v..vv.>..vv..>vv..v..v.v>.v.>.>>vv..>v....>..>v>>..v.>>>vv....v>v>>>..v.v>>v>.....>>>.v...v>.v>.v>v..>>vvv..vv.vv.>vv..v..>.>v.....
    >.v>.v.vv>.>...v>...>.vv..v.>v...v>.vv.>...>.v..>v.>.......vv...>vvv.vv.>.v..v.v..>v>>.v>>.>v.>..v.>....>..v>v....>>....v..>.vv...>v..>>...
    ..>..v>>..v>vv.>.v>.v>..>.vv.v>....v...>>.>vv>v......v....>.>.>>..v.vv>.>v.>>>..>....>..v>>...>..>..v.vv.v.vv.v..>...>>..vv...v...>.v>....>
    .>..>v.>.>v.v..>...v..v..>v>...v..>v..>vv.>.v.>v>..v...>>v>v...>>>>.vv>>.>v>.v>.>.v.v.>vvvv.>>..v...vv>.>...v.vvv>.>>..v.v>.v>v....>.v..v.>
    v>>>.>.v.v..v>.>....>>.>>>>>v>..>>>.vv>v.v.vvvv.>>>v>>>>v>...>.>.>.vv.v...>vvv..>.v.v..>.v>..vv>>v.>.......>.vvv>vv>v.v>v>>v.>....>vv>...>v
    ..>..v....v..vv..v..v.vv..>>>.>..v>>..>.>vvv.v..v..v.>..v>........>.v.v.>>>......>..v>>>.>v>.>vv..>v>v......vv>>>>.>v.>v.v>.>v.>.>.....vv..
    >.>.>v>>.v.v.>..v>>.>v...>...v.>..v>....>vv.>>..>...vv>...>..>v.v.v.vv>.>v.>.>.v.......>>>v>>...>..>v>>vv>.>.>v>v.>...v..>>..>v>>v..v..vv>.
    .>vv>v.>>...vv..>v..v>>>v.v.....v>.....v.>>.......>..v.v>...>vv...>.vvv.v>..>v....>.>..>...>..v.......v.v....>>...>..>....v.vv..vv.v.>..>.>
    v.......>...v.>vv......>..>v>vvv>...>vv.>v>>.>v.>.>...>.....>....>.....v>.>.....>>v.>>>..>.>..>.>..>v>.vv..v.v...>>>.>.vv.>>>v...v...vv>..>
    ..>.v.v.v......v.>>>v.>..>v>>.>>v....>vv....v>.v.vv.v...>v>v...v.v>>.v..>>.>.>.>>v>v>>.>....v>..>..>.v>vv..>....>....v.v...v>..>>>>v....v>.
    .vv.>..>.>>>v.>.v>...>..>>v.>........>>>>.>.>v.v.>...v..>..>v....v..v>....v.....v.v.vvv..>v.v>....vvv...v.>..vvv...v.>>v.>..>>>>.>..v>.>..>
    vv.>...>v.v>v.>>...v.>vv..>.v...>.>>>v.>.v...v...v.v.v..v.v>.>.vv>.>v....v...>..>v>v>.v..vv.>..vv.>...>vvv.vv....v.v>>..v.>.>v..v..>.>.v>.v
    >..>v..>v>vv>v..vvvvvv.>>.>...>...>v....>....>>>>>.v.v.....>v.vv>>>v..v..v.vvv..>v.>vvvv..>v>...>vv.v.>.>.>>>.vv.>>>.vv.>v..vv>>v.vvv.>v>>.
    .vv>..>>>..v.>...v>vvvv.v.>vv....v...vvv..v>..v.vvvv>>.v.v.>>.>.v.>>..v.v..>..>>>.vv...>.>vv.v>>v..>..v.vv.>vv...>v.vv>..>v.>..>vv>.>....v>
    v.>>...>.v>>......v.....v.v.>v.vv>>>...vv.>>v.>.>..>>...>..>.....>....>.v.v.v.>>vv..>>..>...>v.>..>>>.....>>v>>v>..>.v....v......>vv...v.vv
    .......>...vv.vv.>..>v.vv>....>>vvvvv>>...vv...v.vv...v>vvv.v>.>>...>>v>..v.....>.>....v......v.v.>...v......>>>...>v>>>.........>..v.vv.v.
    v.>......v.>v...>.v..vv.v.>.>.>>>...v.v>>...>.>>>>..v.vvv...v..>>vv>.>v>...>....v>>>v...v...vvv..>.>......v>.......>.v.>v..v.vv....v.v.....
    vv..v..v...vv>.>.v.v....v...v..v.vv.v..vvvv..v.>>v.v...>..vvvv.vvv>.v>v>vv...v>.....>.>v>>..v....>.>.v.v.v>vv..>>>v>...vvv>>vvv>.>..v....>.
    vv>.>..>>....v>....v>v..>..>..v.>v....>>>..>...>...>.vv.v>.v.v....>v>>.>......>v..>..>v....>v>v.....>>v.v.>v..vv.>....v.>...>.>v>v.......v>
    >....>>...>>..>.v.>v..v>v>>.>>.>>.v>>>vvv..>.>.vv..vv...>..>>.....>...>.v..>.>v..v...>>>>.>v..v.>..>.....vvv..>.vv.v.v...>>v.>..v>v..>>v...
    .v.>vv>.>.v.>.v.v..>.>>.>vv>v>.>...v..vv>>v.vv.v......vvv>...>.v>.>.v..>v..>.>>>.>..v.v.v..>.....v.vv>.v>v>..>vv>>>......>v.vv>.....>.v.>>v
    ....>....>.v.v.>>vv>.vv.>v.v..>>>.>..v.>>v..>v.>>..>...v>.>>>..>....v.>..vv>.>.v..v..v>.v>>.v.>..v>v....v>v..>...>v.>v.>....vv.>.vv>.>..>>>
    v...v>>.v>>...vvv>...v>...v>vvv.v.vv.>vvv...vv.>>>v..vv>...v>>.>v.>>.....vv.>>.v>v....>........v..>...v.v.v>v>.v>v....v>..>v.v.>..v.>..>.>.
    .vvv>..>.>vv..v...>..>..v.>>..>..>.>v>.....>.v>>>.>.v..>..>.>v..>..v>>.>.....>v....>>.v.....v>..>vv.....v.>.>.>>v.>.vv>...v.>>>.v.>vv...>v.
    ..v.>..vv>>>vv>>.v.>.>..v....vv>v..v......>v...v..>.vv...>>....v...>>v..v..v>v..v.>.>..>>>..v..v..v.>>>>.>.>.>.>.vv.....>vvv>v..>v...>.v>v.
    ..>.v>..vvv..>..v>v.v.v.v.v>.>.>..v>...>v.>>>>>v..vv.v>.>.>>.v....>..vv...>v.....v>..>>>>...v>..vv......v>vvv>>>v.v..>>.v.>..>..>..v..vv>vv
    >>..>..>vv...>>....>.>v..v..>..v>vv..>.>>>.....>...>.vvv.v>v..vvv.>.vv>...>vvv..>v.>.>>..v>.....v.v.vvv.vvv..>v..v>>...>.vv..v>>.v>v.>...>.
    v..>>...vv..>.>.>>.vv..v>>.>.v....>..vvv>>..>v..v>..>v....>v.>v...>...v.>>>.>vv..>vvv>v.>>.v..>..>>.>.v>.v....v.....>>vvv.vv>vvv...>>.>v..v
    ....>>>.>.>v..>>..>>...v>>...v.>vv...>v..v.v>v>vvvv.v>.>>...>>.v.>.vv.>>v>..v.>v>>.vv>........v...>..v>vv.>>.v.>..>..>..>.>.v..>v...>...v>v
    >v.v>v.v...>vvv>.........vv..v>v.>>...v>.>>vv>.v.v.>v..vv..v.v.>.v.>.v..v>.>>..>.>..v>>vv.v.>v..>..>>v.>>>v>...v..v........>..v......v..v.>
    .>....v>.>>.>v.>....>v.v.>.v>.>v>>v.v.>.>>vv.>v....>.>>>>>>...>..v..v.>v.>v.v>v.>.vvv..>>.vv.>...v>.v>>.v.>.....>.v.v.....>.....>>.v.v...>.
    .>>......>>>>.>>...>.....v.v.>..>>v>.>v...>..v>....>>.....vvv>>....>..>>...>v..>v>.>>...v....>v>...v>>.vvv.>vv...v..v.>>vv>.v>>....>..v....
    >...v..>.v.vv..>...>vv...>>..v>.vvv..v..v.v.vv>vvvv..>v.>.v>>.v>>>>>.>v>>v>.vv>>>v....vvv>v..>.>..>.>.>.vv.v>v.>.vv...vv.v.v.>>.>....v.v>.v
    v...v.v.>.>>.>>v.v>..>..v>.....>..v..>v>...v.v.>.>..vv.>.v>v>v.>>v>vv>..>>v..v..v..v..v.vv..v.vv>vv...vv>v.>>v>...>>>....>vv>>v>.>v.v>.>.v>
    .vvv>>.v.>vv.v......>vvvv.v.>v..>>.>...>v..>>v..vv..v...>>..v.>..v>>v>..>vv...>.v.vvv..>.>>>>v..v.....v>v>..>.v.v.v>>>>>v.v.>vv>>.v.>.>....
    >v>.>v..>>.>.v.v.v>.>.....v...v>.>>.>vvv.>.>>.>>vv>>..v.v..vv>..>.....>...>v.vv>.>....>......>>.....v..>>v.>vv...vv.>v..>>vvvv.>>vvvv..v.vv
    >..>..>..>v.vvv...vv>v.>v>v..vvvv.>>.>..v.v.v>>.v.v.v.>vvv......vv>>.>...>.vvv.>v.>vvv>.v..>>.v>vv.vv....>.....>..v>..v.v.>>....v..v>v>.v>v
    >...>....vv>.>v>>..v..>v..>>>....vv>vvv>..>..v>..vv..vvvv.vvvv.>.>v>>..>....v.v..v..>v...>.v>>.v..v.v....>v..v>..v>vvvv..>...>>>>.>v..>>...
    v>..vv....v>>>.v..vv>...v.>>..v..vv>vv>...>.v>...>>..>vv..>.>.>v.>.v...v.v>>v.>.>v>..>..>>vv>>>.>....>...vvv>v....v.v.vv.>>.>.>v..>.v.>vv..
    v>.>.>>...>>>>v...v.>v>v>v>..vv.>>...>v.v.>.v>>.>vv.vvv.v.v.v>.>>v.v.>.vv>.>v>v.v...v.>>v>>v>>v>.v..>>....>>>>vv......vv>>.>vvv....>.vv..v>
    vvv..>..v>>..v.vv>v...vv..>vv>>v..>.v.v...v...>.>.>..>.vv.v.vvv>v>.>vv>v.vvv.v>>..>v...v>>>>v>v..>v..>.v>.v>..>>.>vv>v>>.v>v>v.>.>.....>.v.
    .>>....vv.>>>>.v..>>>>.v.>.>>...>v.>..>....vv>..>>v......>....>..>>..v.v.>..>.vv>...v....vv.v..>>vv.v.>>v.>.>>....>>>>..v.>>..>.>..v>>.>.vv
    >..vv.>..>...>>...>.>>..>v.v..v...vvv..>.>.....>>.>>..vv.v>..>v.>v.v>...v>>>v>...v>>vvv>>v......v>>.v...v.....>>...>v.>v..>>>>.v....vv..>v>
    >.>v.>>>.>..v.....>>>v>.>v.>...v..>..vvv....v...>v..>.v>.v.>.v.>..v>>>>...>>...v.>.v...>.>>v.>v.>>..>v>..v..v.>v.>...v..vv.v.v...>.>.....vv
    .vv>>..>>.v>.>v...vvvvv....>>v..v.>.v>>.>>vv......>>.>>......v..>.v.v>>.vv>.v.>.v>vv.v.>.v......>>.>.v>.>vv>...vv.v...vv.v>v.>v...vvv...v..
    ..vv.>v....>vv>>.....v>vv..v>...v>v.>>vv......v...vvvv..>.>>.>>.....v......vv..v>.v.....>v..vvv.v..v>v......vv.>>>>v....vv..>.v>>....>.>v..
    .>>v>.>.>.>..>v.>v..>>>vvv>v....v.v.>...>.>..>>>..>.>v..>.v.>>v.v.>.v>..>vvv>v......vv..vv.v...>.v...>>..v...v..v....vv>.>..v.v>vv..v..v.vv
    .........>....v.>..>v..v....>.>.vvvv>.>>..v..>....v>>.....v.vv>v..v....>>...>.v..>..>..>.vv.>>>..v>>>>.v..v>>.>.v.>>.>.>v..>.vv>v>>>vvv>.v.
    .>.>.>.v..>...v........v>..v..v>>vv.>>.v...>..>....>>.vv..>v.>.v>...>v...>>.v.v>vv.v>>.>v.v>..>>.v>.>.>>..>.....v>v......v.>v>.v...>.>..>..
    ..>>v..v>>..v>..vv..>>vv>.>>>.v....v.>.>..>..>.v.v>..vvv>vv.>.>v...v>>.v>...>.>v>v.v.>..v.>>vv>..........vv..v>.>v...>>.v>>>..>..>>.>v>..v.
    .....>..>..>..>v.vv>.v>.vv>...>>>.>..>>>..>>vvv.>.>..vv....>v.>..v...>>>v.>.vv.>.v.v...v...>>..v>v...v...v.vv.>.>.>.>v>.>v>v..vv..vvv>>>.v.
    v...>.v.....>.v>..vv.vv.vv...v>.>...>>.>v..>>vv.v.v...vv.....v>.>vv>vv.>>.vvv>..>..>>......>.>vvvv.>v.vv.....>>.>>vvvv.vv>>..>...vv.>..>>..
    >>v.vv>.v...>v.>..v...v.v>>.>..v.>..>>.v>.>.vv>>vvv.v..v>..vv.......vv.>vv..>..>>...>vv.>...>>v.v....>.v>.>>v...>.v>.v..v..v....v>vvv....v.
    v>v.>..v.>.v.>.v..v>>>.v.v>.>.v..v.>.>v.v...>v.v.v....v.>..>v.v>...v>.>.>v>>v.....>v...>vv.>v..>...>>>..v.v.....>>v..>.>..>.>..>>v>>v>>v...
    ...v>>>.>.v>>>..>.vv.v>....vv>vv>v....v...v.v>vv....>>vv.......>.>v>.>.>..>..vv.v>.>>.>.v...v>.>.v.>>..v>.v>.>>.>v..v>....>.v.>..>.vv>.>...
    >...>..vv.v..v..v..v..v..vv.>v.v...v..v.v>..v.>.>.>vv>>..vv..v>>>>>..>.v>.vvv.v...>..>>.>v>>v..>..v>.v>.v>.....>v..>>>vv..>.v>.>.......>...
    .v>...>>>.v.v..>>v..vv.v.v.v......>>>v.>v.v>..v..v>..>v.vv..>.....v....>>v>>....>...>>v..v...>v....v...v>v..v.>.>.vv.v>>vv....>.vv.v....>.v
    .>>.>>v...v.>v>vvv..v...>vv>>>v>v...>.>..>vv..>>>.v>..v>...>vvv.v>v..>.v>v>..>.>...>v....>.v.>....>...v..v.>.v>v...>..v..>v.v.>>>v.>..>v>>.
    >...>.>.vvv>>>v.>v.>>.v..vv.v.>>.>v.v..v...>..>>...v..vvv>.v>.....>>>...vv>vvv...>...v.......v>...>..v.>..>>..v>v....v..>v..v...v.v>...>...
    >..v.v.>vvvvv....v>>v>>v.>.....v....v...v>..v..v.>.>>....v>..v.v>>....>v......>..>>...>v>.vvv.v.>>>>v.v......v.>v>v......>.....vvv........v
    >>.v.>.v..>>.>.>v...v...>.>v>..v>.>v>>.......>....>>>...>v>>v..v...vvv.>...>......>>.vv>..>>>>>...>>v...v..>>.v.>...v...>..>..>..v.>......v
    .>.>>v.vv.>>v.....>vv...>>v>.>.v.>.vv.>...v....>...v.vv>.v..>...v>...>..>v...>>.>>....>.v.>.>..vv.>v>...vv...>>.....>vv.v.vv>vvv..>v..>.>..
    .v.v>.>...vvvv..>...v>v.>vv...v.v.v...vv.>...v..v>>>...vv.>>...>v...>.v>.v>v..vv>>....vv.>.vv..v.>.>..v.......v.v>v>>.v>>vv>v.>.>...>v.v>v.
    >.>v>vv>.>>>....>vv.v..vv>v>v..>..vvvv..vv..>vv.>.v...>.........>vvvvv...>>.v>v>..>v..v>.v.>.>.v..v......>vvvv...v>.>.vv..>>.vv.>>...v.>>..
    ..v...vv.vvv.>..v....v...v.vv>....vv..v..v..v.vv.v..vv..>>>...v.vv>...>..>v......v.v.vv>>v.v.v>.>v>.v.>.vv.v>v..>....v......vv>>v>>>..>....
    ..>..vv...>.>vv.>>..>...>v>..v>vv>.>.v>....>.v...>>v...>v....v.>v...>.>>.>.>v..v.vvv...v>>..v.vvv.>>v>v>v.v>..v>v..>>v....>.vv....v.v.>.v.v
    v>..v...>..>v...v.v>.v>>vv>..>..v..>..v>>.......v..>...v..>.v..>..v...vv..vv>vv.v..>v...v>v>...>v>vv.v..>.>...v....v..>....v.v...>.......v.
    v>.>v.>...v>.v>>..v>...v>.vvv.>v.>vv..vv.>.>..>.>>....>..v..v>.v>v.>.v>v.......v>>>vv..>v>>..v>.>..>v.>>v...v>...>.v..v>v....v.vv.>..v>vv..
    ..v...v......>v>.v...v>...>v...>.vv>v...>...>vv..vv.....>..vv....>v.>..v..>....>>v>.vv..>v>v.>>.>v.....>>...v...vv.v..>.>v>.>v>>v.vv>v>.>v.
    .>.v.vv..v>>.v..>.v>.>..>v>v....>..>v.v.>..>v.v>>v..>...v...>v.v>v...>v>.>v>.....v..v.v>.v.v.v..v...v..v.>.>vv>.v..v>v.v..vv>.>>vv.v...>...
    ..>.v.>..>vv.v....>.>.v.>>..>v.>..>>.>.......>.v.v>>.>......>>...v......v...v.vv.v>..v.>>v>>v>v>v.....>vvv.>>.>.>v..v>>.>...>.v...vv..>>v..
    >.>vvvv>.v..v>..v..vv....v.>v.>vv.v....v.>v.>v..>.vvv..v>.vv>..v..vvv.v..v..>..>..v...>>..>..>..v>vv.v>>vv>.v.vv.>..>..>v.v.>.v.....v.>>.v>
    >vv.v.>..>.>.>v>>>>.>.v.v......v>>>..>.....>v...v>.>>>.>>>.vv..v.........>........v....v.>>....>>vvv.>>..>..v>..v...vv.>>..>.>...>>>>..>...
    vv..v...>.....v.....v.v.v..>>>.>>..>v>.>>..>v..>..>vv.v...v..>.>.......v>>>vv.>.v.>....>..>vvvvv..v..v>>v..v>.>>>.v..v...v>....>v...v.v..>>
    .v.>>...>.>..v.v...>v.v.>...>>vv.vv.v.>>.v...v..v..>.>...>>.....v>>.v>v.v>>..>....v.v.>.vv.>>v.>>v..v>..>.v>>.>v...v.>>v.>..>..v..v>>v.v>vv
    v.>v...v.>.v...>vvv.>>...v..v>.vv>v.v.>.>v..v>v..>.v.>.>.vv>...>......>.>>v>>v.vv...>....>.>>...v>>.v..v>.>......v.v.v>..>.....v.>>v>v.>.>v
    .v>>v.>..>..v>...v>...vvv.v....v.v.>>.v.>..>v.v.>.v>>v>..>.v>..>v...vv..>.v>>>>vv..v..>.>.vv>vv>.v.>.>...v..>v...v...v.v..vvvv.>>>.v>.>v.>v
    vv>..vv>>>v>.>..v..vvvv.v>.v.>v.>v.....>v>vv.>.>>>.v.>v..>...>>..v..>>........>.vvvv...vv>..v>v..vv>...>v>v>.v....>.>.>v>...vv..v>>.v>>.v.>
    v..>.>........>>.>>>..>..>....vvvv.....>..>vv.v.>...>..v...>>v>v.v.v>>v.>>vvv>...v.>.>.>........vvv>v.>v>>>..>.v>.....v.>vv.v.>v..>.......>
    ..>vv.v..v..v>>v...v..>>>v>.v>>>vv.>..>v.>>.>..>.vv>>>>>..>..>.vvv.v.>.>>>>v>...>.>...v..v..v.v>.>..>>v.v>...v>.v.>v..>v.>...>.>v..>.....v.
    """

    var puzzleOcean = OceanFloor(puzzleInput)
    print(puzzleOcean.settle()) // 528 (correct)
}
