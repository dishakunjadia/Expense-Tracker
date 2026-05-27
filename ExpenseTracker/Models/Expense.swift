//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftData
import Foundation

struct Expense: Identifiable, Hashable, Codable{
    /// Mark: Properties
    let id: UUID
    var title: String
    var amount: Double
    var date: Date
    var category: Category
    var member: FamilyMember
    var notes: String?
    //let member : FamilyMember
}
