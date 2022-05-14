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
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    // UserDefault를 사용하여 자동 로그인 구현
    @State private var loginCheck = UserDefaults.standard.bool(forKey: "loginCheck")
    @State private var isSoundOn: Bool = true
    @State private var isVibrationOn: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(Constant.ImageName.defaultUserImage)
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(userInfoManager.userNickName)")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .padding(.top, 25)
                    Text("포메를 두마리 키우고 있는 사람입니다! 잘부탁드려요🥰")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
                    
                    
            }
            List {
                Section("놀러오세요 동물의 집 1.0") {
                    Text("친구에게 추천하기")
                    Text("평가하기")
                    Text("문의하기")
                    Text("개인정보취급방침")
                }
                Section("알람") {
                    Toggle("사운드", isOn: self.$isSoundOn)
                    Toggle("진동", isOn: self.$isVibrationOn)
                    
                }
                
                Section("기타") {
                    Button {
                        self.loginCheck = false
                        UserDefaults.standard.set(self.loginCheck, forKey: "loginCheck")
                        self.viewModel.signOut()
                    } label: {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                }

            }
            .listStyle(.grouped)
        }
        .navigationTitle(Text("⚙️ 설정"))
        .onAppear {
            userInfoManager.getUserNickName()
        }

    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
