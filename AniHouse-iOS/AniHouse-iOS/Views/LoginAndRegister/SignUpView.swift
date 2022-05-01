//
//  SignInView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/27.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nickName: String = ""
    @State private var birthDate: Date = Date()
    
    @State private var email: String = ""
    @State private var firstPwd: String = ""
    @State private var secondPwd: String = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color("Light Gray")
                .ignoresSafeArea()
            
            VStack {
                Form {
                    
                    Section(header: Text("회원정보")) {
                        TextField("성", text: $firstName)
                        TextField("이름", text: $lastName)
                        TextField("닉네임", text: $nickName)
                        DatePicker("생년월일", selection: $birthDate, displayedComponents: .date)
                    }
                    
                    Section(header: Text("계정정보")) {
                        TextField("이메일", text: $email)
                        SecureField("패스워드", text: $firstPwd)
                        SecureField("패스워드를 다시 입력하세요", text: $secondPwd)
                    }
                    
                } // Form
                .navigationTitle("회원가입")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            hideKeyboard()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                        
                        Button("회원가입") {
                            guard !email.isEmpty, !firstPwd.isEmpty else {
                                return
                            }
                            
                            viewModel.signUp(email: email, password: firstPwd)
                            // 회원가입 완료 시, 뒤로 돌아가기 위해서 즉, SignInView로 돌아가기 위함
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } // toolbar
            } // VStack
        } // ZStack
    } // body
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
