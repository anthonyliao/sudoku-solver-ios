//
//  Solver.swift - given a size of puzzle, will solve puzzle
//  sudoku-solver-ios
//
//  Created by ANTHONY on 10/30/14.
//  Copyright (c) 2014 ANTHONY. All rights reserved.
//

import Foundation

class SolverBeta: Printable {
    //How many squares across in the grid
    let gridSize: Int
    //How many squares across for a section
    let sectionSize: Int
    
    //A 2x2 representation of the grid and possible values
    //Given a 2x2 grid:
    //    | 123456789  123456789  |
    //    | 3          6          |
    //Can be represented as [[123456789], [123456789], [3], [6]]
    var squares: [[Int]]
    //For a given square, list of squares (indices in squares array) that are in the row, col, or box
    var peers: [[Int]]
    
    var numSolutions: Int = 0
    
    convenience init(str: String) {
        var array: [Int] = [Int]()
        for (i,j) in enumerate(str) {
            array.append(String(j).toInt()!)
        }
        self.init(initialIntArray: array)
    }
    
    init(initialIntArray: [Int]) {
        self.gridSize = Int(sqrt(Float(initialIntArray.count)))
        self.sectionSize = Int(sqrt(Float(gridSize)))
        
        self.squares = [[Int]]()
        
        for var i = 0; i < initialIntArray.count; i++ {
            if initialIntArray[i] == 0 {
                var solutions = [Int]()
                solutions += 1...self.gridSize
                squares.insert(solutions, atIndex: i)
            } else {
                squares.insert([initialIntArray[i]], atIndex: i)
            }
        }
        LOG.info("squares - \(self.squares)")
        
        self.peers = [[Int]]()
        for var i = 0; i < initialIntArray.count; i++ {
            var peersForI: [Int] = []
            //row peers
            for var j = 0; j < self.gridSize; j++ {
                var peer = ((i / self.gridSize) * self.gridSize) + (j)
                //dont add self
                if i != peer && !contains(peersForI, peer) {
                    peersForI.append(peer)
                }
            }
            //col peers
            for var j = 0; j < self.gridSize; j++ {
                var peer = (i % self.gridSize) + (self.gridSize * j)
                if i != peer && !contains(peersForI, peer) {
                    peersForI.append(peer)
                }
            }
            //box peers
            for var j = 0; j < self.gridSize * self.gridSize; j++ {
                var iRow: Int = i / self.gridSize
                var iCol: Int = i % self.gridSize
                var jRow: Int = j / self.gridSize
                var jCol: Int = j % self.gridSize
                var iBoxRow: Int = iRow / self.sectionSize
                var iBoxCol: Int = iCol / self.sectionSize
                var jBoxRow: Int = jRow / self.sectionSize
                var jBoxCol: Int = jCol / self.sectionSize
                if i != j && !contains(peersForI, j) && iBoxRow == jBoxRow && iBoxCol == jBoxCol {
                    peersForI.append(j)
                }
            }
            
            self.peers.append(peersForI)
        }
        LOG.info("peers - \(self.peers)")
        
        LOG.info("\(self.description)")
    }
    
    init(initial2DArray: [[Int]], peers: [[Int]]) {
        var start = NSDate()
        self.gridSize = Int(sqrt(Float(initial2DArray.count)))
        self.sectionSize = Int(sqrt(Float(gridSize)))
        
        self.squares = initial2DArray
        self.peers = peers
        var end = NSDate().timeIntervalSinceDate(start)
        LOG.info("init duration - \(end)\n\(self.description)")
    }
    
    //Return the current grid in a pretty format
    var description: String {
        get {
            var str: String = "\n"
            
            var maxSquareSize = 1
            for square in squares {
                maxSquareSize = max(maxSquareSize, square.count)
            }
            
            var sectionSeparator = " | "
            var numberSeparator = " "
            var newLine = "\n"
            var dash = "-"
            var padding = " "
            
            var horizontalSectionSeparatorSize = maxSquareSize*self.gridSize + self.gridSize*2*countElements(numberSeparator) + (self.sectionSize+1)*countElements(sectionSeparator)
            
            for var i = 0; i < squares.count; i++ {
                
                //Add section separator after each section
                if i != 0 && i % self.sectionSize == 0 {
                    str += sectionSeparator
                }
                //New line at end of grid
                if i != 0 && i % self.gridSize == 0 {
                    str += newLine
                    //Horizontal section not upcoming
                    if i % (self.sectionSize * self.gridSize) != 0 {
                        str += sectionSeparator
                    }
                }
                //Add horizontal section separator after each section
                if i % (self.sectionSize * self.gridSize) == 0 {
                    for var j = 0; j < horizontalSectionSeparatorSize; j++ {
                        str += dash
                    }
                    str += newLine + sectionSeparator
                }
                
                str += numberSeparator
                
                //Add possible values
                for var j = 0; j < squares[i].count; j++ {
                    str += String(squares[i][j])
                }
                //Pad if short
                for var j = squares[i].count; j < maxSquareSize; j++ {
                    str += padding
                }
                
                str += numberSeparator
            }
            
            //Final section separator
            str += sectionSeparator
            str += newLine
            for var j = 0; j < horizontalSectionSeparatorSize; j++ {
                str += dash
            }
            str += newLine
            
            return str
        }
        
    }
    
    func getCopy() -> [[Int]] {
        var start = NSDate()
        var squaresCopy = [[Int]]()
        for var i = 0; i < self.squares.count; i++ {
            squaresCopy.insert([], atIndex: i)
            for var j = 0; j < self.squares[i].count; j++ {
                squaresCopy[i].append(self.squares[i][j])
            }
        }
        var end = NSDate().timeIntervalSinceDate(start)
        LOG.info("duration - \(end)")
        return squaresCopy
    }
    
    func solve() -> ([[Int]])! {
        //look at solved entries in original puzzle, invalidate these values from peers
        var original = self.getCopy()
        var start = NSDate()
        for var i = 0; i < original.count; i++ {
            var values = original[i]
            if values.count == 1 {
                self.invalidatePeers(i, value: values[0])
            }
        }
        var end = NSDate().timeIntervalSinceDate(start)
        LOG.info("cover in \(end) - \(self.description)")
        
        var start3 = NSDate()
        var idx = self.findSquareWithSmallestPossibleValues()
        var end3 = NSDate().timeIntervalSinceDate(start3)
        LOG.info("smallest possible value find took \(end3)")
        if idx != -1 {
            for var i = 0; i < self.squares[idx].count; i++ {
                var copy = self.getCopy()
                var start4 = NSDate()
                var value = [copy[idx][i]]
                copy[idx] = value
                var end4 = NSDate().timeIntervalSinceDate(start4)
                LOG.info("picked \(idx) to be \(value) in \(end4)")
                var solver = SolverBeta(initial2DArray: copy, peers: peers)
                var solution = solver.solve()
                numSolutions += solver.numSolutions
                if solution != nil {
                    self.squares = solution
                    break
                } else {
                    LOG.info("picked \(idx) to be \(value), invalid - \(self.numSolutions)")
                }
            }
        }
        
        if numSolutions == 0 {
            numSolutions++
        }
        
        var start2 = NSDate()
        if isValidSolution() {
            LOG.info("solution - \(self.description)")
            return self.getCopy()
        }
        var end2 = NSDate().timeIntervalSinceDate(start2)
        LOG.info("validating took \(end2)")
        return nil
    }
    
    func invalidatePeers(square: Int, value: Int) {
        //remove value from square's peers list of possible values
        var peersForSquare = self.peers[square]
        for peer in peersForSquare {
            var numPossibleValuesBefore = self.squares[peer].count
            
            self.squares[peer] = self.squares[peer].filter({ (possibleValue: Int) -> Bool in
                return possibleValue != value
            })
            var numPossibleValuesAfter = self.squares[peer].count
            
            //invalid solution
            if numPossibleValuesAfter == 0 {
                break
            }
            
            //if a peer narrowed possible values down to 1 value, invalidate that value from peer's peer
            if numPossibleValuesBefore > 1 && numPossibleValuesAfter == 1 {
                self.invalidatePeers(peer, value: self.squares[peer][0])
            }
        }
    }
    
    func findSquareWithSmallestPossibleValues() -> Int {
        var minSize = self.gridSize
        var minIndex = -1
        for (i, j) in enumerate(self.squares) {
            if j.count != 1 && j.count < minSize {
                minIndex = i
                minSize = j.count
            }
        }
        return minIndex
    }
    
    func isValidSolution() -> Bool {
        for square in self.squares {
            if square.count != 1 {
                return false
            }
        }
        return true
    }
}