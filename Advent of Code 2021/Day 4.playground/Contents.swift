import Foundation

var greeting = "Hello, playground"

class BingoSquare {
    let number: Int
    var marked: Bool = false
    
    init(_ number: Int) {
        self.number = number
    }
}

class BingoBoard {
    let rows: [[BingoSquare]]
    let columns: [[BingoSquare]]
    
    convenience init(_ string: String) {
        let rows = string.components(separatedBy: .newlines)
        let numbers = rows.map { $0.components(separatedBy: .whitespaces )}
        let ints = numbers.map { $0.compactMap { Int($0) } }
        
        self.init(ints)
    }
    
    init(_ numbers: [[Int]]) {
        let rows = numbers.map { array in
            array.map { int in
                BingoSquare(int)
            }
        }
        
        self.rows = rows
        
        var columns = [[BingoSquare]]()
        
        for i in 0..<numbers.count {
            var column = [BingoSquare]()
            for row in rows {
                column += [row[i]]
            }
            columns += [column]
        }
        
        self.columns = columns
    }
    
    func marked(_ number: Int) {
        for row in rows {
            for square in row {
                if square.number == number {
                    square.marked = true
                    return
                }
            }
        }
    }
    
    var winningNumbers: [BingoSquare]? {
        for row in rows {
            let rowCount = row.count
            let selectedSquares = row.filter { $0.marked }
            let selectedCount = selectedSquares.count
            if selectedCount == rowCount {
                return row
            }
        }
        
        for column in columns {
            let columnCount = column.count
            let selectedSquares = column.filter { $0.marked }
            let selectedCount = selectedSquares.count
            if selectedCount == columnCount {
                return column
            }
        }
        
        return nil
    }
    
    var sumOfUnmarkedNumbers: Int {
        rows.flatMap { $0.filter { $0.marked == false } }
            .reduce(0) { soFar, next in
                soFar + next.number
            }
    }
}

let exampleBoard1 = """
    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19
    """

let rows1 = exampleBoard1.components(separatedBy: .newlines)
let numbers1 = rows1.map { $0.components(separatedBy: .whitespaces )}
let ints1 = numbers1.map { $0.compactMap { Int($0) } }

let board1 = BingoBoard(ints1)

board1.columns[1][1].marked = true

board1 // proves classes are working

board1.marked(8)

board1

board1.winningNumbers

board1.marked(22)
board1.marked(13)
board1.marked(17)
board1.marked(11)

board1.winningNumbers

board1.marked(0)

board1.winningNumbers

let exampleBoard3 = """
    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    """

let board3 = BingoBoard(exampleBoard3)

let exampleInput = [7,4,9,5,11,17,23,2,0,14,21,24]

loop:
for number in exampleInput {
    board3.marked(number)
    
    if let winningNumbers = board3.winningNumbers {
        let score = board3.sumOfUnmarkedNumbers * number // 4512 (correct)
        
        break loop
    }
}
