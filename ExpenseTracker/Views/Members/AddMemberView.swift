//
//  AddMemberView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/27/26.
//

import SwiftUI
import SwiftData

struct AddMemberView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    @State private var avatar: String = ""
    @State private var colorHex: String = "#2196F3"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Member Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                TextField("Avatar Emoji", text: $avatar)
                    .textFieldStyle(.roundedBorder)

                TextField("Color Hex", text: $colorHex)
                    .textFieldStyle(.roundedBorder)

                Button {
                    let member = FamilyMember(
                        id: UUID(),
                        name: name,
                        avatar: avatar,
                        colorHex: colorHex
                    )
                    context.insert(member)
                    try? context.save()
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
}
