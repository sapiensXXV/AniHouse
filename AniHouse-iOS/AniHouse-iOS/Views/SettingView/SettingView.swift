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
    @EnvironmentObject var storageManager: StorageManager
    
    // UserDefault를 사용하여 자동 로그인 구현
    @State private var loginCheck = UserDefaults.standard.bool(forKey: "loginCheck")
    @State private var isSoundOn: Bool = true
    @State private var isVibrationOn: Bool = true
    @State private var showAlert: Bool = false
    @State private var showLogoutAlert: Bool = false
    @State private var showEmailAlert: Bool = false
    @State private var showLaterAlert: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: self.storageManager.profileImage)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .overlay(Circle().stroke(lineWidth: 2))
                    }
                    .padding(.leading, 5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("\(userInfoManager.userNickName)")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .padding(.top, 25)
                            Spacer()
                            NavigationLink {
                                //destination
                                // 내 정보 바꾸기 링크
                                
                            } label: {
                                NavigationLink {
                                    EditProfileView()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .padding(.trailing, 10)
                                        .padding(.top, 25)
                                }
                            }
                        }
                        Text("\(userInfoManager.userIntroduce)")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                    
                }
                List {
                    Section("놀러오세요 동물의 집 1.0") {
                        //                        Button(action: actionSheet) {
                        //                            Text("친구에게 추천하기")
                        //                                .foregroundColor(.black)
                        //                        }
                        Button {
                            self.showAlert = true
                            self.showLaterAlert = true
                            self.showEmailAlert = false
                        } label: {
                            Text("친구에게 추천하기").foregroundColor(.black)
                        }
                        Button {
                            self.showAlert = true
                            self.showLaterAlert = true
                            self.showEmailAlert = false
                        } label: {
                            Text("평가하기").foregroundColor(.black)
                        }
                        Button {
                            self.showAlert = true
                            self.showEmailAlert = true
                            self.showLaterAlert = false
                        } label: {
                            Text("문의하기").foregroundColor(.black)
                        }
                        NavigationLink {
                            PrivacyStatementView()
                        } label: {
                            Text("개인정보취급방침").foregroundColor(.black)
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        if showEmailAlert {
                            return Alert(title: Text("문의사항은 다음 이메일로 연락주세요"), message: Text("anihouse98@gmail.com"), dismissButton: .default(Text("네")))
                        }
                        
                        return Alert(title: Text("추후에 개발할 예정입니다"), message: Text("빨리 업데이트 하겠습니다"), dismissButton: .default(Text("네")))
                        
                    }
                    Section("알람") {
                        Toggle("사운드", isOn: self.$isSoundOn)
                        Toggle("진동", isOn: self.$isVibrationOn)
                        
                    }
                    
                    Section("기타") {
                        NavigationLink {
                            ShowPostDidWrite()
                        } label: {
                            Text("내가 쓴 게시글 보기")
                                .foregroundColor(.black)
                        }
                        
                        
                        
                        Button {
                            self.showLogoutAlert.toggle()
                        } label: {
                            Text("로그아웃")
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: self.$showLogoutAlert) {
                            Alert(title: Text("로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("로그아웃"), action: {
                                self.loginCheck = false
                                storageManager.profileImage = UIImage(named: Constant.ImageName.defaultUserImage)!
                                storageManager.introduce = ""
                                UserDefaults.standard.set(self.loginCheck, forKey: "loginCheck")
                                self.viewModel.signOut()
                                print("로그아웃합니다~")
                            }), secondaryButton: .cancel(Text("취소")))
                        }
                        
                        
                    }
                    
                }
                .listStyle(.grouped)
            }
            .background(Color(Constant.CustomColor.lightBrown))
            .navigationTitle(Text("설정"))
            .navigationBarTitleDisplayMode(.inline)
            
        } // NavigationView
        .onAppear {
            storageManager.getUserProfileImage(email: userInfoManager.user!.email!)
        }
        
    }
    func actionSheet() {
        guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
