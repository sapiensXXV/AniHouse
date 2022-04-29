//
//  MainView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI

enum LayoutType: CaseIterable {
    case all, dog, cat, reptiles, bird, fish
}

extension LayoutType {
    // 레이아웃 타입에 대한 컬럼이 자동으로 설정되도록 한다.
    
}

struct MainView: View {
    
    @State var selectedLayoutType: LayoutType = .all
    
    var testPosts: [MainViewCell] = [
        MainViewCell(),
        MainViewCell(),
        MainViewCell(),
        MainViewCell(),
        MainViewCell(),
        MainViewCell(),
        MainViewCell()
    ]
    
    var columns = [
        GridItem(.flexible(minimum: 120, maximum: 160), spacing: 20, alignment: nil),
        GridItem(.flexible(minimum: 120, maximum: 160), spacing: 20, alignment: nil)
    ]
    
    var body: some View {
        
        var dummyPostArray = MainBoardPost.dummyPostArray
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    Picker(selection: $selectedLayoutType) {
                        //content
                        ForEach(LayoutType.allCases, id: \.self) { layoutType in
                            switch layoutType {
                            case .all:
                                Text("전체")
                            case .dog: Text("멍멍이") // 이제 이런 부분에 따라서 멍멍이, 야옹이 등 게시물만 리턴해야함.
                            case .cat: Text("야옹이")
                            case .reptiles: Text("파충류")
                            case .fish: Text("물고기")
                            case .bird: Text("조류")
                                
                            }
                            
                        }
                    } label: {
                        Text("레이아웃 타입")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 5)
                    .padding(.horizontal, 5)

                    //스크롤 뷰로 감싸서 스크롤이 가능하도록 설정
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            //임시로 더미를 출력
                            ForEach(dummyPostArray, content: { (dataItem: MainBoardPost) in
                                MainViewCell()
                                    .padding(.horizontal, 5)
                                
//                                .background(Color("MainViewCellColor"))
                                
                            })
                        }
                    }
                    
                } // VStack
                
                NavigationLink {
                    AddPostView()
                } label: {
                    Circle()
                        .foregroundColor(Color(Constant.ButtonColor.addButton))
                        .frame(width: 50, height: 50)
                        .padding()
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundColor(Color.white)
                                .font(.system(size: 35))
                        }
                }

            } // ZStack
            .navigationTitle("🐶 우리 가족 소개하기")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
