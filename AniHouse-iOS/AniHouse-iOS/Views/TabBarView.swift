//
//  MainView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/15.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var viewModel = AppViewModel()
    @StateObject var mainFirestoreViewModel = MainPostViewModel()
    @StateObject var storageViewModel = StorageManager()
    @StateObject var userInfoViewModel = UserInfoViewModel()
    
    
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
        .environmentObject(viewModel)
        .environmentObject(mainFirestoreViewModel)
        .environmentObject(storageViewModel)
        .environmentObject(userInfoViewModel)
        .accentColor(Color.blue)
        .onAppear {
            userInfoViewModel.getUserNickName()
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
