//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftData
import Foundation

@Model
class Expense {
    /// Mark: Properties
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var category: Category
    var member: FamilyMember
    var notes: String?
    //let member : FamilyMember
    
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date,
        category:Category,
        member:FamilyMember,
        notes: String?
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.member = member
        self.notes
    }
}
