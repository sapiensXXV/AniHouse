//
//  LoginView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/24.
//

import SwiftUI
import Lottie
import Firebase
import FirebaseAuth

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
        if UserDefaults.standard.bool(forKey: "loginCheck") {
            TabBarView()
        }
        else {
            SignInView()
        }
    }

}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

