//
//  ContentView.swift
//  apple_lab11_05_CRUD_SwiftData_SwiftUI
//
//  Created by developer on 5/23/25.
//

import SwiftUI
import SwiftData

// MARK: - Main Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var teachers: [Teacher]
    @State private var searchText = ""
    @State private var showingAddTeacher = false
    @State private var selectedTeacher: Teacher?
    @State private var showingEditTeacher = false
    
    var filteredTeachers: [Teacher] {
        if searchText.isEmpty {
            return teachers.sorted { $0.lastName < $1.lastName }
        } else {
            return teachers.filter { teacher in
                teacher.fullName.localizedCaseInsensitiveContains(searchText) ||
                teacher.email.localizedCaseInsensitiveContains(searchText) ||
                teacher.subject.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.lastName < $1.lastName }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                
                // Teachers List
                List {
                    ForEach(filteredTeachers, id: \.id) { teacher in
                        TeacherRowView(teacher: teacher)
                            .onTapGesture {
                                selectedTeacher = teacher
                                showingEditTeacher = true
                            }
                    }
                    .onDelete(perform: deleteTeachers)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Teachers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTeacher = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTeacher) {
                AddTeacherView()
            }
            .sheet(item: $selectedTeacher) { teacher in
                EditTeacherView(teacher: teacher)
            }
        }
    }
    
    private func deleteTeachers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredTeachers[index])
            }
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search teachers...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Teacher Row View
struct TeacherRowView: View {
    let teacher: Teacher
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(teacher.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !teacher.isActive {
                    Text("Inactive")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(4)
                }
            }
            
            Text(teacher.subject)
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Text(teacher.email)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Add Teacher View
struct AddTeacherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var phoneNumber = ""
    @State private var dateOfBirth = Date()
    @State private var hireDate = Date()
    @State private var isActive = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                }
                
                Section(header: Text("Professional Information")) {
                    TextField("Subject", text: $subject)
                    DatePicker("Hire Date", selection: $hireDate, displayedComponents: .date)
                    
                    Toggle("Active", isOn: $isActive)
                }
            }
            .navigationTitle("Add Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTeacher()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !subject.isEmpty
    }
    
    private func saveTeacher() {
        let newTeacher = Teacher(
            firstName: firstName,
            lastName: lastName,
            email: email,
            subject: subject,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth,
            hireDate: hireDate,
            isActive: isActive
        )
        
        modelContext.insert(newTeacher)
        dismiss()
    }
}

// MARK: - Edit Teacher View
struct EditTeacherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var teacher: Teacher
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $teacher.firstName)
                    TextField("Last Name", text: $teacher.lastName)
                    TextField("Email", text: $teacher.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone Number", text: $teacher.phoneNumber)
                        .keyboardType(.phonePad)
                    
                    DatePicker("Date of Birth", selection: $teacher.dateOfBirth, displayedComponents: .date)
                }
                
                Section(header: Text("Professional Information")) {
                    TextField("Subject", text: $teacher.subject)
                    DatePicker("Hire Date", selection: $teacher.hireDate, displayedComponents: .date)
                    
                    Toggle("Active", isOn: $teacher.isActive)
                }
                
                Section {
                    Button("Delete Teacher", role: .destructive) {
                        showingDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Edit Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Delete Teacher", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    deleteTeacher()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete \(teacher.fullName)? This action cannot be undone.")
            }
        }
    }
    
    private var isFormValid: Bool {
        !teacher.firstName.isEmpty && !teacher.lastName.isEmpty && !teacher.email.isEmpty && !teacher.subject.isEmpty
    }
    
    private func deleteTeacher() {
        modelContext.delete(teacher)
        dismiss()
    }
}


// MARK: - Preview
#Preview {
    ContentView()
        .modelContainer(for: Teacher.self, inMemory: true)
}
