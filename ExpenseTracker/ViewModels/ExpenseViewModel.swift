//
//  ExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//
import SwiftData
import Foundation
import SwiftUI

@MainActor
class ExpenseViewModel: ObservableObject{
    ///Mark: Published State
    @Published var expenses: [Expense] = []
    @Published var selectedFilter: ExpenseFilter = .all
    @Published var selectedMember: FamilyMember? = nil
    @Published var selectedCategory: Category? = nil
    @Published var familyMembers: [FamilyMember] = [
        FamilyMember( id: UUID(), name: "You", avatar: "👩", colorHex: "Green"),
        FamilyMember( id: UUID(), name: "Mother", avatar: "👩‍🦰", colorHex: "Red"),
        FamilyMember( id: UUID(), name: "Father", avatar: "👨", colorHex: "Blue")

    ]
    
    /// Mark: Init
    
//    init() {
//        loadMockData()
//    }
    
    ///Mark: CRUD
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func deleteExpenses(id: UUID){
        expenses.removeAll() {$0.id == id}
    }
    
    func deleteMember(id: UUID) {
        familyMembers.removeAll(){$0.id == id}
    }
    
    ///Mark: Filtering(do it later)
    var filteredExpenses: [Expense] {
        _ = Calendar.current
        let now = Date()
        
        switch selectedFilter{
        case .all:
            return expenses
        case .weekly:
            return expenses.filter {
                Calendar.current.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
        }
            
        case .monthly:
            return expenses.filter {
                Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month)
            }
        case .yearly:
            return expenses.filter {
                Calendar.current.isDate($0.date, equalTo: now, toGranularity: .year)
            }
        default:
            return expenses
        }
    }
    
//    private func loadMockData() {
//        expenses = [
//            Expense(
//                id: UUID(),
//                title: "Groceries",
//                amount: 120.5,
//                date: Date(),
//                category: .food,
//                member: FamilyMember(id: UUID(), name: "Maate", avatar: "👩", colorHex: "#FF5733"),
//                notes: "Weekly Groceries"
//            ),
//            
//            Expense(
//                            id: UUID(),
//                            title: "Netflix",
//                            amount: 15.99,
//                            date: Date(),
//                            category: .subscriptions,
//                            member: FamilyMember(id: UUID(), name: "Dad", avatar: "👨", colorHex: "#33A1FF"),
//                            notes: nil)
//        ]
//    }
    func saveExpense(
        title: String,
        amount: Double,
        date: Date,
        category: Category,
        member: FamilyMember,
        notes: String?,
        context: ModelContext
    ){
        let expense = Expense( title: title,
            amount: amount,
            date: date,
            category: category,
            member: member,
            notes: notes)
        context.insert(expense)
        
        do {
            try context.save()
        } catch {
            print("Failed to save Expense: \(error)")
        }
    }
    
    
    func saveMember(
        name: String,
        avatar: String,
        colorHex: String,
        context: ModelContext
    ){
        let member = FamilyMember(
            id: UUID(),
            name: name,
            avatar: avatar,
            colorHex: colorHex
        )
        
        context.insert(member)
        do {
            try context.save()
        } catch {
            print("Failed to save member: \(error)")
        }
    }
}
