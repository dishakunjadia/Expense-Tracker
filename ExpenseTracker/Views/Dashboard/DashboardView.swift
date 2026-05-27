//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var showFilterSheet = false
    
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
                        .environmentObject(viewModel)
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
            
            Text("$\(viewModel.expenses.reduce(0) { $0 + $1.amount }, specifier: "%.2f")")
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
                        viewModel.selectedFilter == filter
                        ? Color.cyan
                        : Color(.systemGray6)
                    )
                    .foregroundColor(
                        viewModel.selectedFilter == filter
                        ? Color.mint
                        : .primary
                    )
                    .cornerRadius(10)
                    .onTapGesture{
                        viewModel.selectedFilter = filter
                    }
            }
        }
    }
    
    
    ///#MARK: - Recent Expenses
    
    
    var recentExpenses: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Recent Expenses")
                .font(.headline)
            
            ForEach(viewModel.expenses) { expense in
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
}

#Preview {
    DashboardView()
        .environmentObject(ExpenseViewModel())
}
