//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//
import SwiftUI
import SwiftData

struct DashboardView: View {
    
    // MARK: - SwiftData Queries
    
    @Query(sort: \Expense.date, order: .reverse)
    private var expenses: [Expense]
    
    @Query
    private var familyMembers: [FamilyMember]
    
    // MARK: - States
    
    @State private var selectedSort: ExpenseSort = .dateNewest
    @State private var selectedFilter: ExpenseFilter = .all
    @State private var showFilterSheet = false
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    header
                    
                    weeklyTotal
                    
                    addExpenseButton
                    
                    analyticsButton
                    
                    recentExpenses
                    
                    memberCards
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
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
            .sheet(isPresented: $showFilterSheet) {
                
                FilterSortView()
            }
        }
    }
}

// MARK: - Header

extension DashboardView {
    
    var header: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text("Family Expense Tracker")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Track your spending smartly")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Weekly Total

extension DashboardView {
    
    var weeklyTotal: some View {
        
        VStack(spacing: 8) {
            
            Text("Weekly Total")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(
                "$\(filteredExpenses.reduce(0) { $0 + $1.amount }, specifier: "%.2f")"
            )
            .font(.system(size: 34, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
}

// MARK: - Buttons

extension DashboardView {
    
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
    
    var analyticsButton: some View {
        
        NavigationLink(destination: AnalyticsView()) {
            
            Text("View Analytics")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

// MARK: - Filtering

extension DashboardView {
    
    var filteredExpenses: [Expense] {
        
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
            
        case .all:
            return expenses
            
        case .weekly:
            return expenses.filter {
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
                    toGranularity: .month
                )
            }
            
        case .yearly:
            return expenses.filter {
                calendar.isDate(
                    $0.date,
                    equalTo: now,
                    toGranularity: .year
                )
            }
            
        default:
            return expenses
        }
    }
}

// MARK: - Sorting

extension DashboardView {
    
    var sortedExpenses: [Expense] {
        
        switch selectedSort {
            
        case .dateNewest:
            return filteredExpenses.sorted {
                $0.date > $1.date
            }
            
        case .dateOldest:
            return filteredExpenses.sorted {
                $0.date < $1.date
            }
            
        case .amountHighToLow:
            return filteredExpenses.sorted {
                $0.amount > $1.amount
            }
            
        case .amountLowToHigh:
            return filteredExpenses.sorted {
                $0.amount < $1.amount
            }
        }
    }
}

// MARK: - Recent Expenses

extension DashboardView {
    
    var recentExpenses: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Recent Expenses")
                .font(.headline)
            
            if sortedExpenses.isEmpty {
                
                Text("No expenses added yet")
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
            
            ForEach(sortedExpenses) { expense in
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(expense.title)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(expense.category.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(14)
            }
        }
    }
}

// MARK: - Member Cards

extension DashboardView {
    
    var memberCards: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                
                Text("Family Members")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: MemberManagementView()) {
                    
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            
            if familyMembers.isEmpty {
                
                Text("No members added yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            ForEach(familyMembers) { member in
                
                FamilyMemberExpenseCard(
                    member: member,
                    expenses: expenses.filter {
                        $0.member.id == member.id
                    }
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    
    DashboardView()
        .modelContainer(
            for: [
                Expense.self,
                FamilyMember.self
            ],
            inMemory: true
        )
}

