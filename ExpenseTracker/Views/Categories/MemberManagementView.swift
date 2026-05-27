//
//  MemberManagementView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/27/26.
//

import SwiftUI
import SwiftData

struct MemberManagementView : View{
    //@EnvironmentObject var viewModel: ExpenseViewModel
    
    @Query private var familyMembers: [FamilyMember]
    @Environment(\.modelContext) private var context
    @State private var showAddMemberSheet = false
    @State private var selectedMember: FamilyMember?
    
    var body: some View {
        NavigationView{
            List {
                ForEach(familyMembers) { member in
                    
                    HStack {
                        
                        Text(member.avatar)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            
                            Text(member.name)
                                .fontWeight(.medium)
                            
                            Text(member.colorHex)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedMember = member
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete { indexSet in
                    
                    indexSet.forEach { index in
                        
                        let member = familyMembers[index]
                        
                        context.delete(member)
                        do {
                            try context.save()
                        } catch {
                            print (error)
                        }
                    }
                }
        }
            .navigationTitle("Family Members")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAddMemberSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddMemberSheet) {
                AddMemberView()
                    
            }
            .sheet(item: $selectedMember){ member in
                EditMemberView(member: member)
                    
            }
        }
    }
}

#Preview {
    MemberManagementView()
}
