//
//  RegisterView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/24.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nickName: String = ""
    @State private var birthDate: Date = Date()
    
    @State private var email: String = ""
    @State private var firstPwd: String = ""
    @State private var secondPwd: String = ""
    @State private var loginCheck: Bool = UserDefaults.standard.bool(forKey: "loginCheck")
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
//        ZStack {
        if viewModel.signedIn {
            TabBarView()
        } else {
            SignUpView()
        }
  
//        }
//        .onAppear {
//            viewModel.signedIn = viewModel.isSignedIn
//        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


