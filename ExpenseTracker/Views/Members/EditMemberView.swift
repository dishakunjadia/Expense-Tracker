//
//  EditMemberView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/27/26.
//

import SwiftUI
import SwiftData

struct EditMemberView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    let member: FamilyMember

    @State private var name: String = ""
    @State private var avatar: String = ""
    @State private var colorHex: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                TextField("Avatar Emoji", text: $avatar)
                    .textFieldStyle(.roundedBorder)

                TextField("Color Hex", text: $colorHex)
                    .textFieldStyle(.roundedBorder)

                Button {
                    // ✅ Directly mutate the SwiftData model object
                    member.name = name
                    member.avatar = avatar
                    member.colorHex = colorHex

                    try? context.save()
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
            .onAppear {
                name = member.name
                avatar = member.avatar
                colorHex = member.colorHex
            }
        }
    }
}

#Preview {
    EditMemberView( member: FamilyMember(id: UUID(),
                                         name:"Mom",
                                         avatar: "👩",
                                         colorHex: "#FF5733"))
        .modelContainer(for: FamilyMember.self, inMemory: true)
}
