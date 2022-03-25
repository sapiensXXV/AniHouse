//
//  LoginView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/24.
//

import SwiftUI
import Lottie

struct LoginView: View {
    @State var userId: String = ""
    @State var userPassword: String = ""
    
    var body: some View {
        ZStack {
            Color("Light Gray")
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("동물의 집")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 0)
                LottieView("walking_dog", .loop)
                    .frame(width: 200, height: 200)
                
                TextField("아이디를 입력하세요", text: $userId)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("비밀번호를 입력하세요", text: $userPassword)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
                
                //로그인버튼
                Button {
                    //action
                    print("Login Button Clicked")
                } label: {
                    Text("로그인")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 120, height: 40)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Spacer()
                Button {
                    //action
                    
                } label: {
                    Text("아직 회원이 아니신가요? 회원가입")
                }


                
                
            }
            .padding(.horizontal, 20)
        }
        
    }
}

//struct LottieView: UIViewRepresentable {
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
//    }
//}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

