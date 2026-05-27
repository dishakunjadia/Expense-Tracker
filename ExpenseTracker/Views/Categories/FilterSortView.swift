//
//  FilterSortView.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import SwiftUI

struct FilterSortView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                filterSection
                //sortSection
                Spacer()
                applyButton
            }
            .padding()
            .navigationTitle("Filter & Sort")
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
        
//    var sortSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            
//            Label("Sort By", systemImage: "arrow.up.arrow.down.circle")
//                .font(.headline)
//            
//            ForEach(ExpenseSort.allCases, id: \.self) { sort in
//                
//                HStack {
//                    
//                    Image(systemName: sortIcon(for: sort))
//                    
//                    Text(sort.title)
//                    
//                    Spacer()
//                    
//                    if viewModel.selectedSort == sort {
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.green)
//                    }
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .onTapGesture {
//                    viewModel.selectedSort = sort
//                }
//            }
//        }
//    }
//    
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
