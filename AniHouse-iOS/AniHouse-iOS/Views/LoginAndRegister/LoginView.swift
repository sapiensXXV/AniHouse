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
    // UserDefault를 사용하여 자동 로그인 구현
    @State private var loginCheck = UserDefaults.standard.bool(forKey: "loginCheck")

    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var mainFireStoreViewModel: MainPostViewModel
    @EnvironmentObject var storageViewModel: StorageManager
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    
    var body: some View {
//        NavigationView {
        if UserDefaults.standard.bool(forKey: "loginCheck") {
                let _ = print("viewModel.signedIn: \(viewModel.signedIn)")
//                MainView()
                // 로그인 성공하면 바로 TabBarView로 이동
                TabBarView()
//                .environmentObject(viewModel)
//                .envi
                
                // 이미 로그인 한 유저의 경우 이곳을 통해 홈 뷰로 이동.
            }
            else {
                SignInView()
            }
//        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

