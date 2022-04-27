//
//  MainView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/15.
//

import SwiftUI

struct MainView: View {
    @State private var showingSheet = false
    private var category = ["전체", "강아지", "고양이", "물고기", "새", "기타"]
    @State private var selectedCategory = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            Text("배너")
            Picker("카테고리", selection: $selectedCategory){
                ForEach(0 ..< 6) {
                    Text(self.category[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            ScrollView(){
                LazyVGrid(columns: columns){
                    ForEach(1..<13) { number in
                        Image("dog" + String(number))
                            .resizable()
                            .frame(height: 150)
                    }
                }
            }
            .overlay(
                Button(action: {
                    self.showingSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(Circle())
                })
                .padding(5)
                .sheet(isPresented: self.$showingSheet) {
                    AddPostView()
                }
                ,alignment: .bottomTrailing
            )
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
