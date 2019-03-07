//
//  FixedTable.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit

/*
 // Example Usage
 
 let cellA = UITableViewCell(style: .value1, reuseIdentifier: "CellA")
 let cellB = UITableViewCell(style: .value1, reuseIdentifier: "CellB")
 let cellC = UITableViewCell(style: .value1, reuseIdentifier: "CellC")

 let fixedTable = FixedTable(cells: [0:cellA, 1:cellB, 2:cellC])
 
 for cell in fixedTable { print(cell.reuseIdentifier) }  // Outputs: CellA, CellB, CellC

 fixedTable.setSwitch(for: cellB, to: false) // turn off CellB

 for cell in fixedTable { print(cell.reuseIdentifier) }  // Outputs: CellA, CellC
 */

/// Image an array where you can insert table view cells, give them an order, and turn them on/off while maintaining that order.
class FixedTable: Collection {
    
    typealias Priority = Int
    private typealias CellHash = Int
    
    init(cells: [Priority:UITableViewCell]) {
        for (priority, cell) in cells {
            switches[priority] = true
            priorities[cell.hashValue] = priority
        }
        
        for (_, cell) in cells {
            inOrderInsert(cell)
        }
    }
    
    var sectionNumber = 0
    private var priorities = [CellHash : Priority]()
    private var switches = [Priority : Bool]()
    private var array = [UITableViewCell]()
    
    @discardableResult
    func setSwitch(for cell: UITableViewCell, to value: Bool) -> Bool {
        guard let priority = priorities[cell.hashValue] else { return false }
        guard switches[priority] != value else { return true }
        
        switches[priority] = value
        
        switch value {
        case true: inOrderInsert(cell)
        case false: array.remove(at: arrayIndex(for: cell))
        }
        
        return true
    }
    
    private func arrayIndex(for cell: UITableViewCell) -> Index {
        let priority = priorities[cell.hashValue]!
        return array.firstIndex(where:{ priority == priorities[$0.hashValue] })!
    }
    
    private func inOrderInsert(_ cell: UITableViewCell) {
        guard !array.isEmpty else {
            array.insert(cell, at: 0)
            return
        }
        let destinationIndex = array.firstIndex(where: { priorities[cell.hashValue]! <= priorities[$0.hashValue]! }) ?? self.endIndex
        array.insert(cell, at: destinationIndex)
    }
    
    // MARK: Collection
    
    var startIndex: Int { return array.startIndex }
    var endIndex: Int { return array.endIndex }
    
    func index(after i: Int) -> Int { return array.index(after: i) }
    
    subscript(index: Int) -> UITableViewCell { return array[index] }
}
