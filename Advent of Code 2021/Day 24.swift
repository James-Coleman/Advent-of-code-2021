//
//  Day 24.swift
//  Advent of Code 2021
//
//  Created by James Coleman on 24/12/2021.
//

import Foundation

func day24() {
    enum Error: Swift.Error {
        case emptyOperation
        case unknownInstruction(String)
        case inputOperationWithoutTwoParameters
        case mathematicalOperationWithoutThreeParameters
        case inputIsNotInt(String)
        case tryingToDivideByZero
        case tryingToModuloByZero
        case nilInput
    }

    func inp(_ input: Int, operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 2 else { throw Error.inputOperationWithoutTwoParameters }
        
        dict[operation[1]] = input
    }

    func add(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        let int1 = dict[operation[1]] ?? Int(operation[1]) ?? 0
        let int2 = dict[operation[2]] ?? Int(operation[2]) ?? 0
        
        let sum = int1 + int2
        
        dict[operation[1]] = sum
    }

    func mul(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        let int1 = dict[operation[1]] ?? Int(operation[1]) ?? 0
        let int2 = dict[operation[2]] ?? Int(operation[2]) ?? 0
        
        let product = int1 * int2
        
        dict[operation[1]] = product
    }

    func div(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        let int1 = dict[operation[1]] ?? Int(operation[1]) ?? 0
        let int2 = dict[operation[2]] ?? Int(operation[2]) ?? 0
        
        guard int2 > 0 else { throw Error.tryingToDivideByZero }
        
        let (divided, _) = int1.quotientAndRemainder(dividingBy: int2)
        
        dict[operation[1]] = divided
    }

    func mod(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        let int1 = dict[operation[1]] ?? Int(operation[1]) ?? 0
        let int2 = dict[operation[2]] ?? Int(operation[2]) ?? 0
        
        guard int1 >= 0 else { throw Error.tryingToModuloByZero }
        guard int2 > 0 else { throw Error.tryingToModuloByZero }
        
        let (_, remainder) = int1.quotientAndRemainder(dividingBy: int2)
        
        dict[operation[1]] = remainder
    }

    func eql(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        let int1 = dict[operation[1]] ?? Int(operation[1]) ?? 0
        let int2 = dict[operation[2]] ?? Int(operation[2]) ?? 0
        
        dict[operation[1]] = int1 == int2 ? 1 : 0
    }
    
    func execute(_ instructions: String, input: [Int]) throws -> [String: Int] {
        var dict: [String: Int] = ["w": 0, "x": 0, "y": 0, "z": 0]
        
        let components = instructions.components(separatedBy: .newlines)
        
        var inputCount = 0
        
        for line in components {
            let operation = line.components(separatedBy: .whitespaces)
            
            guard let instruction = operation.first else { throw Error.emptyOperation }
            
            switch instruction {
                case "inp":
                    try inp(input[inputCount], operation: operation, on: &dict)
                    inputCount += 1
                case "add":
                    try add(operation: operation, on: &dict)
                case "mul":
                    try mul(operation: operation, on: &dict)
                case "div":
                    try div(operation: operation, on: &dict)
                case "mod":
                    try mod(operation: operation, on: &dict)
                case "eql":
                    try eql(operation: operation, on: &dict)
                default:
                    throw Error.unknownInstruction(instruction)
            }
        }
        
        return dict
    }
    
    let puzzleInput = """
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 12
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 14
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 12
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 11
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -9
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 12
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -7
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 11
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 2
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -1
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 11
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -16
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 11
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 10
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -15
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 2
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 10
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 0
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 1
        add x 12
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 0
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x -4
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        inp w
        mul x 0
        add x z
        mod x 26
        div z 26
        add x 0
        eql x w
        eql x 0
        mul y 0
        add y 25
        mul y x
        add y 1
        mul z y
        mul y 0
        add y w
        add y 15
        mul y x
        add z y
        """

    func nextNumber(previousNumber: [Int]) -> [Int] {
        var newNumber = previousNumber
        
        for (index, int) in newNumber.enumerated().reversed() {
            let newInt = int - 1
            
            if newInt == 0 {
                newNumber[index] = 9
            } else {
                newNumber[index] = newInt
                break
            }
        }
        
        return newNumber
    }

    func part1() throws -> [Int] {
        var arrayToTest = Array(repeating: 9, count: 14)
        
        var dict = try execute(puzzleInput, input: arrayToTest)
        
        while dict["z"] != 0 {
            arrayToTest = nextNumber(previousNumber: arrayToTest)
            print(arrayToTest, dict["z"])
            dict = try execute(puzzleInput, input: arrayToTest)
        }
        
        return arrayToTest
    }

    do {
        print(try part1())
    } catch {
        print(error)
    }
}
