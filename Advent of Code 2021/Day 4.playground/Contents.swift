import Foundation

var greeting = "Hello, playground"

class BingoSquare {
    let number: Int
    var selected: Bool = false
    
    init(_ number: Int) {
        self.number = number
    }
}

class BingoBoard {
    let rows: [[BingoSquare]]
    let columns: [[BingoSquare]]
    
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
    
    func selected(_ number: Int) {
        for row in rows {
            for square in row {
                if square.number == number {
                    square.selected = true
                    return
                }
            }
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

board1.columns[1][1].selected = true

board1 // proves classes are working

board1.selected(8)

board1
