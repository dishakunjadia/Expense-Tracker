//
//  AnalyticsView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI
struct AnalyticsView: View{
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    var body: some View{
        VStack(spacing: 16){
            
            Text("Analytics")
                .font(.title2)
                .bold()
            
            analyticsGrid
            
            Spacer()
        }
        .padding()
        .navigationTitle("Analytics")
    }
    
    var totalExpense: String {
        let total = viewModel.expenses.reduce(0){$0 + $1.amount}
        return "$\(String(format: "%.2f", total))"
    }
    
    var averageExpense: String{
        guard !viewModel.expenses.isEmpty else {return "$0.00"}
        let total = viewModel.expenses.reduce(0){$0 + $1.amount}
        return "$\(String(format: "%.2f", total / Double(viewModel.expenses.count)))"
    }
    
    var topCategory: String {
        let grouped = Dictionary(grouping: viewModel.expenses, by: {$0.category})
        let sorted = grouped.mapValues{$0.reduce(0){$0 + $1.amount}}
        return sorted.max(by: {$0.value < $1.value})?.key.rawValue.description.capitalized ?? "N/A"
    }
    
    func card(title: String, value: String) -> some View{
        VStack{
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemMint))
        .cornerRadius(12)
    }
    var analyticsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            card(title: "Total", value: totalExpense)
            card(title: "Expenses", value: "\(viewModel.expenses.count)")
            card(title: "Average", value: averageExpense)
            card(title: "Top Category", value: topCategory)
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(ExpenseViewModel())
}
