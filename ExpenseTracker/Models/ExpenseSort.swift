//
//  ExpenseSort.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/28/26.
//

import Foundation

enum ExpenseSort: String, CaseIterable {
    case dateNewest = "Newest First"
    case dateOldest = "Oldest First"
    case amountHighToLow = "Highest Amount"
    case amountLowToHigh = "Lowest Amount"
    
    var title: String {
        rawValue
    }
}
