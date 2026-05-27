//
//  FamilyMember.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import Foundation

struct FamilyMember: Identifiable, Codable, Hashable{
    let id: UUID
    var name: String
    var avatar: String
    var colorHex: String
}
