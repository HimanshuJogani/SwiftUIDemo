//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Himanshu Jogani on 09/07/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showAddSheet = false
    @State private var selectedEntry: PasswordEntryEntity? = nil
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if viewModel.isAuthenticated {
                    GeometryReader { geometry in
                        VStack {
                            if viewModel.entries.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("No saved passwords")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height - 70)
                            } else {
                                ScrollView {
                                    VStack(spacing: 30) {
                                        ForEach(viewModel.entries) { entry in
                                            Button(action: {
                                                selectedEntry = entry
                                            }) {
                                                HStack(spacing: 12) {
                                                    Text(entry.accountType ?? "Unknown")
                                                        .font(.headline)
                                                    if let id = entry.id,
                                                       let password = KeychainHelper.shared.getPassword(for: id) {
                                                        Text(String(repeating: "*", count: max(password.count, 8)))
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    } else {
                                                        Text("No password")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                    
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                }
                                                .padding()
                                                .background( RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color(.white))
                                                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2))
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .navigationTitle("Password Manager")
                    }
                    
                    Button(action: {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Rectangle())
                            .cornerRadius(10)
                        
                    }
                    .padding()
                    .accessibilityIdentifier("AddButton")
                } else {
                    Button("Authenticate") {
                        viewModel.authenticate()
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            PasswordDetailView(entry: entry, viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showAddSheet) {
            AddPasswordView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ContentView()
}
