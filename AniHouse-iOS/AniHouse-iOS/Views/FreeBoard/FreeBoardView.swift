//
//  FreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

struct FreeBoardView: View {
    @State private var title = ""
    @State private var isActive = false
    @State private var search = false
    @State private var searchTitle = ""
    @State private var isPresented = true
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var storageManager: StorageManager
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        TextField("게시글 제목을 검색하세요", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .frame(width: 270)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        Button(action: {
                            search = true
                            searchTitle = title
                            title = ""
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.black)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // List는 ScrollView 안써도 스크롤 생기면서 모든 게시글이 보이는데
                // ForEach는 ScrollView 써야지만 스크롤 생기면서 모든 게시글이 보인다.
                ZStack(alignment: .bottom) {
                    ScrollView {
                        ForEach(freeFirestoreViewModel.freeBoardContents) { data in
                            // 게시글 제목 검색 기능
                            if search == true && data.title.contains(searchTitle) {
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: SelectedFreeBoardView(post: data, showingOverlay: $isPresented)) {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                //                                            폰트명: KoreanSDNR-B, KoreanSDNR-M
                                                Text("\(data.title)")
                                                //                                                .font(.system(size: 25))
                                                    .font(.system(size: 16))
                                                    .fontWeight(.black)
                                                    .lineLimit(1)
                                                Spacer()
                                                Image(systemName: "heart.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 11, height: 11)
                                                    .foregroundColor(.red)
                                                Text("\(data.hit)")
                                                    .font(.system(size: 13))
                                                    .lineLimit(1)
                                            }
                                            Text("\(data.body)")
                                                .font(.system(size: 13))
                                                .lineLimit(1)
                                        }
                                        .padding()
                                    }
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                            }
                            else if search == false || searchTitle == "" {
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: SelectedFreeBoardView(post: data, showingOverlay: $isPresented)) {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                //                                            폰트명: KoreanSDNR-B, KoreanSDNR-M
                                                Text("\(data.title)")
                                                //                                                .font(.system(size: 25))
                                                    .font(.system(size: 16))
                                                    .fontWeight(.black)
                                                    .lineLimit(1)
                                                Spacer()
                                                Image(systemName: "heart.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 11, height: 11)
                                                    .foregroundColor(.red)
                                                Text("\(data.hit)")
                                                    .font(.system(size: 13))
                                                    .lineLimit(1)
                                            }
                                            Text("\(data.body)")
                                                .font(.system(size: 13))
                                                .lineLimit(1)
                                        }
                                        .padding()
                                    }
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                    Spacer()
                                }
                                .listRowSeparator(.hidden)
                                
                            }
                        }
                        .background(Color(Constant.CustomColor.lightBrown))
                        .listStyle(PlainListStyle())
                    }

                    NavigationLink {
                        AddFreeBoardView()
                    } label: {
                        HStack {
                            Image("pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                            Text("글 쓰기")
                        }
                        .frame(width: 100, height: 20)
                        .padding()
                        .background(Color(Constant.CustomColor.normalBrown))
                    }
                    .foregroundColor(.black)
                    .background(Color("board-add-button"))
                    .cornerRadius(.infinity)
                    .padding(5)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color(Constant.CustomColor.lightBrown))
            .onAppear {
                isPresented = true
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let user = user {
                        print("유저의 정보를 찾았습니다.")
                        print(user.email)
                        self.userInfoManager.getUserNickName(email: user.email!)
                    } else {
                        print("기다리고 있어요...")
                    }
                }
                freeFirestoreViewModel.getData()
                
                
                //                            UITableView.appearance().backgroundColor = .clear
                //                            UITableViewCell.appearance().backgroundColor = .clear
            }
        }
    }
}

struct FreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FreeBoardView()
    }
}


// swipe하여 뒤로 가기 기능
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
