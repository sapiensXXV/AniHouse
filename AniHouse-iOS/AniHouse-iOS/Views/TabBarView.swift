//
//  MainView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/15.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var storageViewModel: StorageManager
    @EnvironmentObject var userInfoViewModel: UserInfoViewModel
    
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: "", author: "", hit:0, hitCheck: false))).environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "text.alignleft")
                        .foregroundColor(Color.blue)
                    Text("자유게시판")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("설정")
                }
        }
//        .environmentObject(viewModel)
//        .environmentObject(mainFirestoreViewModel)
//        .environmentObject(storageViewModel)
//        .environmentObject(userInfoViewModel)
        .accentColor(Color.blue)
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                print("닉네임 다시찾ㄱ")
//                userInfoViewModel.getUserNickName()
//                
//            }
//            userInfoViewModel.getUserNickName()
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
