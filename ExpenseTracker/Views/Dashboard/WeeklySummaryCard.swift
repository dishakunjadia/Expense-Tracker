//
//  WeeklySummaryCard.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//


import SwiftUI

struct WeeklySummaryCard: View {
    
    @State private var expandedCategory: String? = nil
    
    let mockExpenses: [WeeklyCategoryExpense] = [
        
        WeeklyCategoryExpense(
            title: "Groceries",
            icon: "cart.fill",
            total: 210,
            details: [
                WeeklyExpenseDetail(day: "Mon",
                                    title: "Costco",
                                    amount: 120)
            ]
        ),
        
        WeeklyCategoryExpense(
            title: "Rent",
            icon: "house.fill",
            total: 1200,
            details: [
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Greenhouse management",
                                    amount: 1200)
            ]
        ),
        
        WeeklyCategoryExpense(
            title: "Utilities",
            icon: "bolt.fill",
            total: 140,
            details: [
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Electricity",
                                    amount: 20),
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Internet",
                                    amount: 120)
                
            ]
        ),
        
        WeeklyCategoryExpense(
            title: "Office Meals",
            icon: "fork.knife",
            total: 85,
            details: [
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Coffee",
                                    amount: 25),
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Lunch",
                                    amount: 15),
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Dinner",
                                    amount: 45)
            ]
        ),
        
        WeeklyCategoryExpense(
            title: "Allowances",
            icon: "figure.2.and.child.holdinghands",
            total: 160,
            details: [
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Mia ",
                                    amount: 80),
                WeeklyExpenseDetail(day: "Tue",
                                    title: "Sam",
                                    amount: 80)
            ]
        )
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                header
                
                categoryList
            }
            .padding()
        }
    }
}


// MARK: - Header

extension WeeklySummaryCard {
    
    var header: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text("Weekly Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Entire family expenses")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
}


// MARK: - Grid Layout

extension WeeklySummaryCard {
    
    var categoryList: some View {
        
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 165))
            ],
            spacing: 14
        ) {
            
            ForEach(mockExpenses) { expense in
                categoryRow(for: expense)
            }
        }
    }
}


// MARK: - Category Card

extension WeeklySummaryCard {
    
    func categoryRow(for expense: WeeklyCategoryExpense) -> some View {
        
        VStack(spacing: 8) {
            
            Button {
                
                if expandedCategory == expense.title {
                    expandedCategory = nil
                } else {
                    expandedCategory = expense.title
                }
                
            } label: {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    // Top Row
                    HStack {
                        
                        Image(systemName: expense.icon)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Image(systemName:
                                expandedCategory == expense.title
                              ? "chevron.up"
                              : "chevron.down"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    
                    // Category Name
                    Text(expense.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                    
                    
                    // Amount
                    Text("$\(expense.total, specifier: "%.0f")")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 130)
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemMint).opacity(0.18))
                )
            }
            .buttonStyle(.plain)
            
            
            // Expanded Details
            if expandedCategory == expense.title {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    ForEach(expense.details) { detail in
                        
                        HStack(spacing: 10) {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Text(detail.day)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text(detail.title)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("$\(detail.amount, specifier: "%.0f")")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemGray6))
                )
            }
        }
    }
}


// MARK: - Model

struct WeeklyCategoryExpense: Identifiable {
    
    let id = UUID()
    
    let title: String
    
    let icon: String
    
    let total: Double
    
    let details: [WeeklyExpenseDetail]
}

struct WeeklyExpenseDetail: Identifiable{
    let id = UUID()
    let day: String
    let title: String
    let amount: Double
}

// MARK: - Preview

#Preview {
    WeeklySummaryCard()
}

