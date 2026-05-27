//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    
    //@EnvironmentObject var viewModel: ExpenseViewModel
    @Query(sort: \Expense.date, order: .reverse)
    private var expenses: [Expense]
    
    @Query
    private var familyMembers: [FamilyMember]

    @State private var showFilterSheet = false
    @State private var selectedFilter: ExpenseFilter = .all
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    header
                    weeklyTotal
                    addExpenseButton
                    analyticsButton
                    recentExpenses
    
                    Spacer()
                }
                .padding()
                .navigationTitle("Dashboard")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showFilterSheet = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .sheet(isPresented: $showFilterSheet){
                    FilterSortView()
                        
                }
            }
        }
    }
    
    ///#MARK: - Header
    
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Family Expense Tracker")
                .font(.title2)
                .bold()
            
            Text("Track your spending smartly")
                .font(.subheadline)
                .foregroundColor(.secondary)
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    ///#MARK: - Weekly Total
    
    var weeklyTotal: some View {
        VStack(spacing: 6) {
            
            Text("Weekly Total")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("$\(filteredExpenses.reduce(0) { $0 + $1.amount }, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    ///#MARK: - Add Expense Button
    
    var addExpenseButton: some View {
        NavigationLink(destination: AddExpenseView()) {
            Text("Add Expense")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
    ///#MARK: - Analytics Button
    
    var analyticsButton: some View{
        NavigationLink(destination: AnalyticsView()){
            Text("View Analytics")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            
        }
    }
    
    ///#Mark: - Filter Row
    
    var filterRow: some View{
        HStack(spacing:10){
            ForEach(ExpenseFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue)
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        selectedFilter == filter
                        ? Color.cyan
                        : Color(.systemGray6)
                    )
                    .foregroundColor(
                        selectedFilter == filter
                        ? Color.mint
                        : .primary
                    )
                    .cornerRadius(10)
                    .onTapGesture{
                        selectedFilter = filter
                    }
            }
        }
    }
    
    ///#MARK: - Filtered Expenses
    var filteredExpenses: [Expense]{
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .all:
            return expenses
        case .weekly:
            return expenses.filter{
                calendar.isDate(
                    $0.date,
                    equalTo: now,
                    toGranularity: .weekOfYear
                )
            }
        case .monthly:
            return expenses.filter {
                calendar.isDate(
                    $0.date,
                    equalTo: now,
                    toGranularity: .month)
            }
        case .yearly:
            return expenses.filter {
                calendar.isDate(
                    $0.date,
                    equalTo: now,
                    toGranularity: .year)
            }
        case .byMember:
            <#code#>
        case .byCategory:
            <#code#>
        case .dateNewest:
            <#code#>
        case .dateoldest:
            <#code#>
        case .amountHighToLow:
            <#code#>
        case .amountLowToHigh:
            <#code#>
        }
    }
    
    ///#MARK: - Recent Expenses

    var recentExpenses: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Recent Expenses")
                .font(.headline)
            
            ForEach(expenses) { expense in
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(expense.title)
                            .font(.subheadline)
                            .bold()
                        
                        Text(expense.category.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .bold()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    ///#MARK: - Individual Members

    var memberCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Family Members")
                .font(.headline)
            ForEach(familyMembers) { member in
                
                FamilyMemberExpenseCard(member: member, expenses: expenses.filter{
                    $0.member.id == member.id
                })
            }
        }
    }
    
}

#Preview {
    DashboardView()
        
}
