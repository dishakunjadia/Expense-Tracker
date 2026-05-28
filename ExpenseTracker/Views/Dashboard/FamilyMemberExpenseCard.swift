//
//  FamilyMemberExpenseCard.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI

struct FamilyMemberExpenseCard: View {

    let member: FamilyMember
    let expenses: [Expense]
    
    var totalSpent: Double{
        expenses.reduce(0){$0 + $1.amount}
    }
    
    var topCategory: String{
        let grouped = Dictionary(grouping: expenses){
            $0.category.rawValue
        }
        return grouped.max{
            $0.value.count < $1.value.count
        }?.key.capitalized ?? "None"
    }
    
    var body: some View {
        VStack {
            HStack {
                
//                Image(systemName: member.icon)
//                    .font(.title2)
//                    .foregroundColor(member.color)
                VStack(alignment: .leading, spacing: 2){
                    
                    Text(member.name)
                        .font(.headline)
                    
                    Text("Weekly Spend")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("$\(totalSpent, specifier: "%.0f")")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading, spacing: 6){
                Text("Top Category")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack{
                    Image(systemName: "chart.pie.fill")
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 10){
                Text("Recent Expenses")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ForEach(expenses.prefix(3)) { expense in
                    HStack {
                        Text(expense.date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(expense.title)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("$\(expense.amount, specifier: "%.0f")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            
            Button{
                
            } label: {
                Text("View Details")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.mint.opacity(0.15))
                    .foregroundColor(Color.mint)
                    .cornerRadius(12)
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemGray6))
        )
        
    }
    
    
    
}

#Preview {
    
    FamilyMemberExpenseCard(
        
        member: FamilyMember(
            id: UUID(),
            name: "Mother",
            avatar: "👩",
            colorHex: "#FF5733"
        ),
        
        expenses: [
            
            Expense(
                id: UUID(),
                title: "Groceries",
                amount: 120,
                date: Date(),
                category: .food,
                member: FamilyMember(
                    id: UUID(),
                    name: "Mother",
                    avatar: "👩",
                    colorHex: "#FF5733"
                ),
                notes: nil
            ),
            
            Expense(
                id: UUID(),
                title: "Coffee",
                amount: 18,
                date: Date(),
                category: .food,
                member: FamilyMember(
                    id: UUID(),
                    name: "Mother",
                    avatar: "👩",
                    colorHex: "#FF5733"
                ),
                notes: nil
            )
        ]
    )
    .padding()
}

