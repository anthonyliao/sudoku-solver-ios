//
//  Solver.swift - given a size of puzzle, will solve puzzle
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import Foundation

enum SudokuCodes {
    case Solved
    case Invalid
    case Fork
}

class Solver: Printable {
    let size: Int
    let squares: [[Square]]
    var invalidPuzzle: Bool
    
    init(size: Int) {
        self.size = size
        self.squares = [[Square]]()
        for var i = 0; i < size; i++ {
            squares.insert([], atIndex: i)
            for var j = 0; j < size; j++ {
                squares[i].append(Square(x: i, y: j, size: size))
            }
        }
        self.invalidPuzzle = false
    }
    
    init(initialArray: [[Int]]) {
        self.size = initialArray.count
        self.squares = [[Square]]()
        for var i = 0; i < self.size; i++ {
            self.squares.insert([], atIndex: i)
            for var j = 0; j < self.size; j++ {
                if initialArray[i][j] == 0 {
                    squares[i].append(Square(x: i, y: j, size: self.size))
                } else {
                    squares[i].append(Square(x: i, y: j, answers: [initialArray[i][j]]))
                }
            }
        }
        self.invalidPuzzle = false
    }
    
    init(initialSquare: [[Square]]) {
        self.size = initialSquare.count
        self.squares = initialSquare
        self.invalidPuzzle = false
    }
    
    var description: String {
        get {
            var desc: String = ""
            for var i = 0; i < self.size; i++ {
                for var j = 0; j < self.size; j++ {
                    desc += "\(squares[i][j]) | "
                }
                desc += "\n\n"
            }
            return desc
        }
    }
    
    func getSquare(x: Int, y: Int) -> Square {
        return squares[x][y]
    }
    
    func getCopy() -> [[Square]] {
        var squaresCopy = [[Square]]()
        for var i = 0; i < self.size; i++ {
            squaresCopy.insert([], atIndex: i)
            for var j = 0; j < self.size; j++ {
                var square = self.getSquare(i, y: j)
                squaresCopy[i].append(Square(x: square.x, y: square.y, answers: square.answers))
            }
        }
        return squaresCopy
    }
    
    func chooseArbitrarySquare(solver: Solver) -> Square? {
        for row in solver.squares {
            for square in row {
                if !square.isSolved() {
                    LOG.info("chose arbitrary - \(square)")
                    return square
                }
            }
        }
        return nil
    }
    
    func solve() -> SudokuCodes {
        var zeroInvalidations = true
        var passes = 0
        do {
            zeroInvalidations = self.solveIteration()
            LOG.info("--------------")
            LOG.info("\n\(description)")
            LOG.info("--------------")
            passes++
        } while (zeroInvalidations == false && self.invalidPuzzle == false)
        
        if self.invalidPuzzle {
            LOG.info("sudoku puzzle impossible to solve - \(self.invalidPuzzle), invalid")
            return SudokuCodes.Invalid
        } else if zeroInvalidations && validatePuzzle() {
            LOG.info("sudoku solved in \(passes) passes, solved")
            return SudokuCodes.Solved
        }
        LOG.info("sudoku unsolved in \(passes) passes, fork")
        LOG.info("\n----fork---")
        LOG.info("\n\(description)")
        LOG.info("\n--------------")
        var code: SudokuCodes = SudokuCodes.Invalid
        var chosenSquare = self.chooseArbitrarySquare(self)!
        
        for var i = 0; i < chosenSquare.answers.count; i++ {
            var answer = chosenSquare.answers[i]
            var solver = Solver(initialSquare: self.getCopy())
            solver.getSquare(chosenSquare.x, y: chosenSquare.y).answers = [answer]
            code = solver.solve()
            if code == SudokuCodes.Solved {
                break
            } else {
                continue
            }
        }
        return code
    }
    
    func solveIteration() -> Bool {
        var zeroInvalidations = true
        
        for var i = 0; i < self.size; i++ {
            for var j = 0; j < self.size; j++ {
                var square = self.getSquare(i, y: j)
                if square.isSolved() && self.invalidPuzzle == false {
                    zeroInvalidations = zeroInvalidations & self.invalidateRow(i, answer: square.getAnswer()!, solvedSquare: square)
                    zeroInvalidations = zeroInvalidations & self.invalidateColumn(j, answer: square.getAnswer()!, solvedSquare: square)
                    var root = Int(sqrt(Float(self.size)))
                    zeroInvalidations = zeroInvalidations & self.invalidateBox(i/root, j: j/root, answer: square.getAnswer()!, solvedSquare: square)
                }
            }
        }
        
        return zeroInvalidations
    }
    
    func invalidateRow(i: Int, answer: Int, solvedSquare: Square) -> Bool {
        var allValid = true
        for var j = 0; j < self.size; j++ {
            var square = self.getSquare(i, y: j)
            //same square, we can skip
            if solvedSquare == square {
                continue
            }
            
            //different square, but answer is the same. invalid puzzle
            if square.isSolved() && square.getAnswer()! == answer {
                LOG.info("\(solvedSquare) and \(square) have the same answer - \(answer)")
                self.invalidPuzzle = self.invalidPuzzle | true
                break
            }
            
            if !square.isSolved() && contains(square.answers, answer) {
//                LOG.info("invalidate \(i),\(j) - \(answer) from \(square.answers)")
                square.removeInvalidAnswer(answer)
                allValid = false
            }
        }
        return allValid
    }
    
    func invalidateColumn(j: Int, answer: Int, solvedSquare: Square) -> Bool {
        var allValid = true
        for var i = 0; i < self.size; i++ {
            var square = self.getSquare(i, y: j)
            //same square, we can skip
            if solvedSquare == square {
                continue
            }
            
            //different square, but answer is the same. invalid puzzle
            if square.isSolved() && square.getAnswer()! == answer {
                LOG.info("\(solvedSquare) and \(square) have the same answer - \(answer)")
                self.invalidPuzzle = self.invalidPuzzle | true
                break
            }
            
            if !square.isSolved() && contains(square.answers, answer) {
//                LOG.info("invalidate \(i),\(j) - \(answer) from \(square.answers)")
                square.removeInvalidAnswer(answer)
                allValid = false
            }
        }
        return allValid
    }
    
    func invalidateBox(i: Int, j: Int, answer: Int, solvedSquare: Square) -> Bool {
        var allValid = true
        var root = Int(sqrt(Float(self.size)))
        for var x = i * root; x < (i+1) * root; x++ {
            for var y = j * root; y < (j+1) * root; y++ {
                var square = self.getSquare(x, y: y)
                //same square, we can skip
                if solvedSquare == square {
                    continue
                }
                
                //different square, but answer is the same. invalid puzzle
                if square.isSolved() && square.getAnswer()! == answer {
                    LOG.info("\(solvedSquare) and \(square) have the same answer - \(answer)")
                    self.invalidPuzzle = self.invalidPuzzle | true
                    break
                }
                
                if !square.isSolved() && contains(square.answers, answer) {
//                    LOG.info("invalidate \(x),\(y) - \(answer) from \(square.answers)")
                    square.removeInvalidAnswer(answer)
                    allValid = false
                }
            }
        }
        return allValid
    }
    
    func validatePuzzle() -> Bool {
        for row in self.squares {
            for square in row {
                if !square.isSolved() {
                    return false
                }
            }
        }
        return true
    }
}