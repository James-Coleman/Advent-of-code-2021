import Foundation

var greeting = "Hello, playground"

func part1(player1Start: Int, player2Start: Int) -> Int? {
    var player1Position = player1Start
    var player2Position = player2Start
    
    var player1Score = 0
    var player2Score = 0
    
    var diceNumber = 1
    
    var currentPlayer = 1
    
    var diceRolls = 0
    
    func rollDice() {
        diceNumber += 1
        if diceNumber == 101 {
            diceNumber = 1
        }
        diceRolls += 1
    }
    
    while player1Score < 1000 && player2Score < 1000 {
        var totalMoves = 0
        
        for _ in 1...3 {
            totalMoves += diceNumber
            rollDice()
        }
        
        if currentPlayer == 1 {
            player1Position += totalMoves
            while player1Position > 10 {
                player1Position -= 10
            }
            player1Score += player1Position
        } else {
            player2Position += totalMoves
            while player2Position > 10 {
                player2Position -= 10
            }
            player2Score += player2Position
        }
        
        currentPlayer = currentPlayer == 1 ? 2 : 1
    }
    
    if let losingPlayer = [player1Score, player2Score].sorted(by: <).first {
        return losingPlayer * diceRolls
    } else {
        return nil
    }
}

//part1(player1Start: 4, player2Start: 8) // 739785 (correct)
part1(player1Start: 8, player2Start: 6) // 503478 (correct)
