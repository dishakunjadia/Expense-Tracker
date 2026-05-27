//
//  FamilyMember.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//
import SwiftData
import Foundation

@Model
class FamilyMember {
    var id: UUID
    var name: String
    var avatar: String
    var colorHex: String
    
    init(
        id: UUID = UUID(),
        name: String,
        avatar: String,
        colorHex: String
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.colorHex = colorHex
    }
}
