//
//  ExpenseFilter.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import Foundation

enum ExpenseFilter : String, CaseIterable{
    case all = "All"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    case byMember
    case byCategory
    case dateNewest
    case dateOldest
    case amountHighToLow
    case amountLowToHigh
}


