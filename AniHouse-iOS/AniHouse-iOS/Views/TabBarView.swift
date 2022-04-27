//
//  MainView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/15.
//

import SwiftUI

struct TabBarView: View {
    let viewModel = AppViewModel()
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: 0))).environmentObject(viewModel)
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
        .accentColor(Color.blue)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
