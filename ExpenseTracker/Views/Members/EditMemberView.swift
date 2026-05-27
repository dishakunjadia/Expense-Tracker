//
//  EditMemberView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/27/26.
//

import SwiftUI

struct EditMemberView: View{
    @EnvironmentObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) var dismiss
    
    let member: FamilyMember
    
    @State private var name: String = ""
    @State private var avatar: String = ""
    @State private var colorHex: String = ""
    
    var body : some View {
        NavigationView{
            VStack(spacing: 20){
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Avatar", text: $avatar)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Color Hex", text: $colorHex)
                    .textFieldStyle(.roundedBorder)
                
                Button{
                    if let index = viewModel.familyMembers.firstIndex(where: {
                        $0.id == member.id
                    }) {
                        viewModel.familyMembers[index].name = name
                        viewModel.familyMembers[index].avatar = avatar
                        viewModel.familyMembers[index].colorHex = colorHex
                    }
                    dismiss()
                } label: {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Member")
            .onAppear{
                name = member.name
                avatar = member.avatar
                colorHex = member.colorHex
            }
        }
    }
}

#Preview {
    EditMemberView(
        member: FamilyMember(
            id: UUID(),
            name: "Mother",
            avatar: "👩",
            colorHex: "#FF5733"))
    .environmentObject(ExpenseViewModel())
}
