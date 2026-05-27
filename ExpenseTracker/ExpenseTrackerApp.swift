//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    @StateObject private var viewModel = ExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(viewModel)
        }
        .modelContainer(for: [
            Expense.self,
            FamilyMember.self
        ])
    }
}
