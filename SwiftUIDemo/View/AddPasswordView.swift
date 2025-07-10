//
//  AddPasswordView.swift
//  SwiftUIPractice
//
//  Created by Himanshu Jogani on 09/07/25.
//

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PasswordViewModel
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var accountType: String = ""
    @State private var isPasswordVisible: Bool = false
    
    private var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !accountType.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray)
                .padding(.top, 8)
            
            TextField("Username / Email", text: $username)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .font(.system(size: 18, weight: .medium))
            
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .font(.system(size: 18, weight: .medium))
            
            if !password.isEmpty && password.count < 6 {
                Text("Password must be at least 6 characters")
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }
            
            TextField("Account Name", text: $accountType)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .font(.system(size: 18, weight: .medium))
            
            Spacer().frame(height: 24)
            
            Button("Add New Account") {
                viewModel.add(accountType: accountType, username: username, password: password)
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isFormValid ? Color.black : Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .disabled(!isFormValid)
            
            Spacer()
        }
        .padding()
    }
}
