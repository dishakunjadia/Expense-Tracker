//
//  AddMemberView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/27/26.
//

import SwiftUI

struct AddMemberView: View {
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var avatar: String = ""
    @State private var colorHex: String = "#2196F3"
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                TextField("Member Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Avatar Emoji", text: $avatar)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Color Hex", text: $colorHex)
                    .textFieldStyle(.roundedBorder)
                
                Button{
                    let member = FamilyMember(
                        id: UUID(),
                        name: name,
                        avatar: avatar,
                        colorHex: colorHex
                    )
                    
                    viewModel.familyMembers.append(member)
                    dismiss()
                } label: {
                    Text("Add Member")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Add Member")
        }
    }
}

#Preview {
    AddMemberView()
        .environmentObject(ExpenseViewModel())
}
