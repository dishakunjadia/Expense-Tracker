//
//  FilterSortView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI

struct FilterSortView: View {
    @State private var showMemberSheet = false
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 24) {
                filterSection
                manageMembersButton
                Spacer()
                applyButton
            }
            .padding()
            .navigationTitle("Filter & Sort")
            .sheet(isPresented: $showMemberSheet) {
                MemberManagementView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    func icon(for filter: ExpenseFilter) -> String {
        switch filter {
        case .all:
            return "tray.full"
        case .weekly:
            return "calendar"
        case .monthly:
            return "calendar.circle"
        case .yearly:
            return "calendar.badge.clock"
        case .byMember:
            return "person.fill"
        case .byCategory:
            return "filemenu.and.selection"
        case .dateNewest:
            return "clock.arrow.circlepath"
        case .dateoldest:
            return "clock"
        case .amountHighToLow:
            return "arrow.down.circle"
        case .amountLowToHigh:
            return "arrow.up.circle"
        
        }
    }
    var filterSection: some View{
        VStack(alignment: .leading, spacing: 12){
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .font(.headline)
            ForEach(ExpenseFilter.allCases, id: \.self) { filter in
                HStack{
                    Image(systemName: icon(for:filter))
                    Text(filter.rawValue)
                    Spacer()
                    
                    if viewModel.selectedFilter == filter {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.cyan)
                    }
                    
                }
            }
        }
    }
        
    var manageMembersButton: some View {
        Button {
            showMemberSheet = true
        } label: {
            HStack {
                Image(systemName: "person.3.fill")
                Text("Manage Family Members")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding()
            .background()
            .cornerRadius(12)
        }
    }
    
    var applyButton: some View{
        Button(action:{
            dismiss()
        }){
            Text("Apply")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

#Preview {
    FilterSortView()
        .environmentObject(ExpenseViewModel())
}
