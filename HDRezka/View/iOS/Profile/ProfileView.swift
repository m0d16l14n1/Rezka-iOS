//
//  ProfileView.swift
//  HDRezka
//
//  Created by keet on 30.09.2023.
//

import SwiftUI
import Alamofire

struct ProfileView: View {
    @State private var username = ""
    @State private var password = ""
    
    @State private var loggedIn = false
    
    @EnvironmentObject var accountService: AccountService
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ожидает обновления")
//                if !loggedIn {
//                    TextField("Username", text: $username)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                    
//                    SecureField("Password", text: $password)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                    
//                    Button {
//                        Task {
//                            try await accountService.login(username: username, password: password)
//                            loggedIn = checkStatus()
//                        }
//                    } label: {
//                        Text("login")
//                    }
//                } else {
//                    Button {
//                        Task {
//                            await AF.session.reset()
//                            loggedIn = checkStatus()
//                        }
//                    } label: {
//                        Text("logout")
//                    }
//                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        DonationsListView()
                            .environmentObject(DonationManager())
                    } label: {
                        Image(systemName: "gift")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                            .environmentObject(Network())
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .onAppear {
                loggedIn = checkStatus()
            }
        }
    }
    
    fileprivate func checkStatus() -> Bool {
        let isLoggedIn = HTTPCookieStorage.shared.cookies!.map { cookie in
            if cookie.name.contains("dle_password") {
                return true
            } else {
                return false
            }
        }
        
        if isLoggedIn.description.contains("true") {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AccountService())
}
