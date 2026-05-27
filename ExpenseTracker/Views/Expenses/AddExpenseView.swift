//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI
import SwiftData


struct AddExpenseView: View {
    @Query private var familyMembers: [FamilyMember]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedCategory: Category = .food
    @State private var selectedDate: Date = Date()
    @State private var selectedMember: FamilyMember?
    
    var body: some View {
        NavigationView {
            
            VStack {
                formFields
                
                Spacer()
                
                saveButton
            }
            .padding()
            .navigationTitle("Add Expense")
            .onAppear{
                selectedMember = familyMembers.first
            }
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
            
            
            Picker("Family Member", selection: $selectedMember){
                ForEach(familyMembers, id: \.self) { member in
                    HStack {
                        Text(member.avatar)
                        Text(member.name)
                    }
                    .tag(member as FamilyMember?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
        }
    }
    
    // MARK: - Save Button
    var saveButton: some View {
        Button(action: {
            guard let selectedMember else {return}
            
            let expense = Expense(
                id: UUID(),
                title: title,
                amount: Double(amount) ?? 0,
                date: selectedDate,
                category: selectedCategory,
                member: selectedMember,
                notes: nil
            )
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            dismiss()
            
            //print("Save Tapped")
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
