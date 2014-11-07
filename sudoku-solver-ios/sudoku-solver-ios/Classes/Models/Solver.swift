//
//  Solver.swift - given a size of puzzle, will solve puzzle
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import Foundation

class Solver: Printable {
    let size: Int
    let squares: [[Square]]
    
    init(size: Int) {
        self.size = size
        self.squares = [[Square]]()
        for var i = 0; i < size; i++ {
            squares.insert([], atIndex: i)
            for var j = 0; j < size; j++ {
                squares[i].append(Square(x: i, y: j, size: size))
            }
        }
    }
    
    init(initialSquare: [[Int]]) {
        self.size = initialSquare.count
        self.squares = [[Square]]()
        for var i = 0; i < self.size; i++ {
            self.squares.insert([], atIndex: i)
            for var j = 0; j < self.size; j++ {
                if initialSquare[i][j] == 0 {
                    squares[i].append(Square(x: i, y: j, size: self.size))
                } else {
                    squares[i].append(Square(x: i, y: j, answers: [initialSquare[i][j]]))
                }
            }
        }
        LOG.info("\(description)")
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
    
    func solve() {
        var allSolved = true
        var passes = 0
        do {
            allSolved = self.solveIteration()
            LOG.info("--------------")
            LOG.info("\n\(description)")
            LOG.info("--------------")
            passes++
        } while (allSolved == false)
        LOG.info("sudoku solved in \(passes) passes - \(allSolved)")
    }
    
    func solveIteration() -> Bool {
        var solved = true
        
        for var i = 0; i < self.size; i++ {
            for var j = 0; j < self.size; j++ {
                var square = self.getSquare(i, y: j)
                if square.isSolved() {
                    solved = solved & self.invalidateRow(i, answer: square.getAnswer()!)
                    solved = solved & self.invalidateColumn(j, answer: square.getAnswer()!)
                    var root = Int(sqrt(Float(self.size)))
                    solved = solved & self.invalidateBox(i/root, j: j/root, answer: square.getAnswer()!)
                }
            }
        }
        
        return solved
    }
    
    func invalidateRow(i: Int, answer: Int) -> Bool {
        var allValid = true
        for var j = 0; j < self.size; j++ {
            var square = self.getSquare(i, y: j)
            if !square.isSolved() && contains(square.answers, answer) {
                LOG.info("invalidate \(i),\(j) - \(answer) from \(square.answers)")
                square.removeInvalidAnswer(answer)
                allValid = false
            }
        }
        return allValid
    }
    
    func invalidateColumn(j: Int, answer: Int) -> Bool {
        var allValid = true
        for var i = 0; i < self.size; i++ {
            var square = self.getSquare(i, y: j)
            if !square.isSolved() && contains(square.answers, answer) {
                LOG.info("invalidate \(i),\(j) - \(answer) from \(square.answers)")
                square.removeInvalidAnswer(answer)
                allValid = false
            }
        }
        return allValid
    }
    
    func invalidateBox(i: Int, j: Int, answer: Int) -> Bool {
        var allValid = true
        var root = Int(sqrt(Float(self.size)))
        for var x = i * root; x < (i+1) * root; x++ {
            for var y = j * root; y < (j+1) * root; y++ {
                var square = self.getSquare(x, y: y)
                if !square.isSolved() && contains(square.answers, answer) {
                    LOG.info("invalidate \(x),\(y) - \(answer) from \(square.answers)")
                    square.removeInvalidAnswer(answer)
                    allValid = false
                }
            }
        }
        return allValid
    }
}