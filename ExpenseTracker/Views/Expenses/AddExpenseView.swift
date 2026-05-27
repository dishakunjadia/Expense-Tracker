//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI

struct AddExpenseView: View {
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedCategory: Category = .food
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack {
                formFields
                
                Spacer()
                
                saveButton
            }
            .padding()
            .navigationTitle("Add Expense")
        }
    }
    
    // MARK: - Form Fields
    var formFields: some View {
        VStack(spacing: 16) {
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                        .tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
        }
    }
    
    // MARK: - Save Button
    var saveButton: some View {
        Button(action: {
            print("Save Tapped")
        }) {
            Text("Save Expense")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

#Preview {
    AddExpenseView()
}
