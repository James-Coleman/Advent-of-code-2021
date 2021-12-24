import Foundation

var greeting = "Hello, playground"

enum Error: Swift.Error {
    case emptyOperation
    case unknownInstruction(String)
    case inputOperationWithoutTwoParameters
    case mathematicalOperationWithoutThreeParameters
    case inputIsNotInt(String)
    case dictDoesNotContainVariables(String)
    case tryingToDivideByZero
    case tryingToModuloByZero
}

func execute(operation: [String], on dict: inout [String: Int]) throws {
    /// This is wrong, the input should be a separate integer
    func inp(_ input: Int, operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 2 else { throw Error.inputOperationWithoutTwoParameters }
        
        dict[operation[1]] = input
    }
    
    func add(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        guard let int1 = dict[operation[1]] else { throw Error.dictDoesNotContainVariables(operation[1]) }
        guard let int2 = dict[operation[2]] else { throw Error.dictDoesNotContainVariables(operation[2]) }
        
        let sum = int1 + int2
        
        dict[operation[1]] = sum
    }
    
    func mul(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        guard let int1 = dict[operation[1]] else { throw Error.dictDoesNotContainVariables(operation[1]) }
        guard let int2 = dict[operation[2]] else { throw Error.dictDoesNotContainVariables(operation[2]) }
        
        let product = int1 * int2
        
        dict[operation[1]] = product
    }
    
    func div(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        guard let int1 = dict[operation[1]] else { throw Error.dictDoesNotContainVariables(operation[1]) }
        guard let int2 = dict[operation[2]] else { throw Error.dictDoesNotContainVariables(operation[2]) }
        
        guard int2 > 0 else { throw Error.tryingToDivideByZero }
        
        let (divided, _) = int1.quotientAndRemainder(dividingBy: int2)
        
        dict[operation[1]] = divided
    }
    
    func mod(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        guard let int1 = dict[operation[1]] else { throw Error.dictDoesNotContainVariables(operation[1]) }
        guard let int2 = dict[operation[2]] else { throw Error.dictDoesNotContainVariables(operation[2]) }
        
        guard int1 >= 0 else { throw Error.tryingToModuloByZero }
        guard int2 > 0 else { throw Error.tryingToModuloByZero }
        
        let (_, remainder) = int1.quotientAndRemainder(dividingBy: int2)
        
        dict[operation[1]] = remainder
    }
    
    func eql(operation: [String], on dict: inout [String: Int]) throws {
        guard operation.count >= 3 else { throw Error.mathematicalOperationWithoutThreeParameters }
        
        guard let int1 = dict[operation[1]] else { throw Error.dictDoesNotContainVariables(operation[1]) }
        guard let int2 = dict[operation[2]] else { throw Error.dictDoesNotContainVariables(operation[2]) }
        
        dict[operation[1]] = int1 == int2 ? 1 : 0
    }
    
    guard let instruction = operation.first else { throw Error.emptyOperation }
    
    switch instruction {
        case "inp":
            try inp(1, operation: operation, on: &dict)
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

let example1 = """
inp x
mul x -1
"""


