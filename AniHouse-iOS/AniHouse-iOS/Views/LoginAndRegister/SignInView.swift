//
//  SignInView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/27.
//

import SwiftUI
import Lottie

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State private var isShowingAlert = UserDefaults.standard.bool(forKey: "loginCheck")
    // UserDefault를 사용하여 자동 로그인 구현
    @State private var loginCheck = UserDefaults.standard.bool(forKey: "loginCheck")

    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Light Gray")
                    .ignoresSafeArea()
                VStack {
                    //                    Spacer()
                    Text("동물의 집")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 0)
                    LottieView("walking_dog", .loop)
                        .frame(width: 200, height: 200)
                    
                    TextField("이메일를 입력하세요", text: $email)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("비밀번호를 입력하세요", text: $password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 20)
                    
                    //로그인버튼
                    Button {
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        viewModel.signIn(email: email, password: password)
                        // viewModel.signedIn이 비동기적으로 처리되는데 이를 기다리지 않고
                        // 즉, isShowingAlert을 동기적으로 처리하지 않아서 isShowingAlert 값이 viewModel.signedIn이 반영되지 않은 상태였음.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            isShowingAlert = !viewModel.signedIn // 실제 로그인 여부와 반대로 값을 받는다.
                            isShowingAlert = !UserDefaults.standard.bool(forKey: "loginCheck")
                        }
                        self.loginCheck = true
                        UserDefaults.standard.set(self.loginCheck, forKey: "loginCheck")
                        
                    } label: {
                        Text("로그인")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .frame(width: 120, height: 40)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .alert("등록되지 않은 계정입니다",
                           isPresented: $isShowingAlert,
                           actions: {}) {
                        Text("이메일과 비밀번호를 한번 더 확인해주세요")
                    } // iOS15 이후의 알림방식
                    Spacer()
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("아직 회원이 아니신가요? 회원가입")
                        
                    } // NavigationView
                    
                } // VStack
                .padding(.horizontal, 20)
            } // ZStack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //action
                        hideKeyboard()
                    } label: {
                        //label
                        Image(systemName: "keyboard.chevron.compact.down")
                        
                    }
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
