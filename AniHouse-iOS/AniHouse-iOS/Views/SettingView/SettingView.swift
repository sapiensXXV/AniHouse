//
//  SettingView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/15.
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    // UserDefault를 사용하여 자동 로그인 구현
    @State private var loginCheck = UserDefaults.standard.bool(forKey: "loginCheck")

    var body: some View {
        VStack {
            Text("this is setting view")
            
            Button {
                self.loginCheck = false
                UserDefaults.standard.set(self.loginCheck, forKey: "loginCheck")
                viewModel.signOut()
            } label: {
                Text("Sign Out")
            }
            .foregroundColor(Color.white)
            .padding(.horizontal, 50)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(8)
        }

    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
