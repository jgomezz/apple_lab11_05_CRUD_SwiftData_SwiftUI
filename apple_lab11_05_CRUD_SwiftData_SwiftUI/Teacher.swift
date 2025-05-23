//
//  Teacher.swift
//  apple_lab11_05_CRUD_SwiftData_SwiftUI
//
//  Created by developer on 5/23/25.
//

import SwiftUI
import SwiftData

// MARK: - Teacher Model
@Model
final class Teacher {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var subject: String
    var phoneNumber: String
    var dateOfBirth: Date
    var hireDate: Date
    var isActive: Bool
    
    init(firstName: String, lastName: String, email: String, subject: String, phoneNumber: String, dateOfBirth: Date, hireDate: Date, isActive: Bool = true) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.subject = subject
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.hireDate = hireDate
        self.isActive = isActive
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
