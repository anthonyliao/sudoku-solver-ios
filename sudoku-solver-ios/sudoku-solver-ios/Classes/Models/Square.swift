//
//  Square.swift - a sudoku square model, holds potential answers to given square
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import Foundation

class Square: Printable, Equatable {
    let x: Int
    let y: Int
    var answers: [Int]
    var description: String {
        get {
            return "\(x),\(y) - \(answers)"
        }
    }
    
    init(x: Int, y: Int, answers: [Int]) {
        self.x = x
        self.y = y
        self.answers = []
        self.answers.extend(answers)
    }
    
    init(x: Int, y: Int, size: Int) {
        self.x = x
        self.y = y
        self.answers = [Int]()
        for var i = 1; i <= size; i++ {
            self.answers.append(i)
        }
    }
    
    func removeInvalidAnswer(answer: Int) {
        self.answers = self.answers.filter { (element: Int) -> Bool in
            if element == answer {
                return false
            }
            return true
        }
    }
    
    func isSolved() -> Bool {
        return (self.answers.count == 1)
    }
    
    func getAnswer() -> Int? {
        if isSolved() {
            return self.answers[0]
        }
        return nil
    }
    
}

func == (lhs: Square, rhs: Square) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}