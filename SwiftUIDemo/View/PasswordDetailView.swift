//
//  PasswordDetailView.swift
//  SwiftUIPractice
//
//  Created by Himanshu Jogani on 09/07/25.
//

import SwiftUI

struct PasswordDetailView: View {
    var entry: PasswordEntryEntity
    @ObservedObject var viewModel: PasswordViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isEditing = false
    @State private var isPasswordVisible = false
    @State private var originalPassword: String = ""
    @Environment(\.dismiss) var dismiss
    
    init(entry: PasswordEntryEntity, viewModel: PasswordViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _username = State(initialValue: entry.username ?? "")
        if let id = entry.id, let savedPassword = KeychainHelper.shared.getPassword(for: id) {
            _password = State(initialValue: savedPassword)
            _originalPassword = State(initialValue: savedPassword)
        } else {
            _password = State(initialValue: "")
            _originalPassword = State(initialValue: "")
        }
    }
    
    private var isPasswordValid: Bool {
        password.count >= 6
    }
    
    private var isFormChanged: Bool {
        username != entry.username || password != originalPassword
    }
    
    private var isUpdateButtonEnabled: Bool {
        isEditing && isFormChanged && isPasswordValid && !username.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule().frame(width: 40, height: 5).foregroundColor(.gray).padding(.top,8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Account Details")
                    .padding(.vertical)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Account Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(entry.accountType ?? "")
                    .font(.headline)
                Text("Username/Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!isEditing)
                
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                ZStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .disabled(!isEditing)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Password", text: $password)
                            .disabled(!isEditing)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 12)
                        .disabled(!isEditing)
                    }
                )
                
                if isEditing && !isPasswordValid {
                    Text("Password must be at least 6 characters")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
            }
            
            HStack(spacing: 12) {
                Button(isEditing ? "Update" : "Edit") {
                    if isEditing {
                        viewModel.update(entry, username: username, password: password)
                        dismiss()
                    } else {
                        isEditing = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEditing ? (isUpdateButtonEnabled ? Color.green : Color.gray.opacity(0.4)) : Color.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .disabled(isEditing && !isUpdateButtonEnabled)
                
                Button("Delete") {
                    viewModel.delete(entry)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.9))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding(.top,20)
            
            Spacer()
        }
        .padding()
    }
}
