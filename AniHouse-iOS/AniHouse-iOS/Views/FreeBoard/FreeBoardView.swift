//
//  FreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import SwiftUI

struct FreeBoardView: View {
    @State private var title = ""
    @State private var showModal = false
    @ObservedObject private var viewModel = FreeBoardViewModel()
//    @Binding var selectedTitle:String
//    @Binding var selectedBody:String
    @Binding var selectedData: FreeBoardContent
    @State private var search = false
    @State private var searchTitle = ""
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("게시글 제목을 검색하세요", text: $title)
                        .frame(width: 200)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                    Button(action: {
                        search = true
                        searchTitle = title
                        title = ""
                    }) {
                       Image(systemName: "magnifyingglass")
                    }
                        .padding()
                    Button(action: {
                        showModal = true
                    }) {
                       Image(systemName: "plus")
                    }
                        .padding()
                    // 게시글 추가 Modal View
                    .sheet(isPresented: self.$showModal) {
                        AddFreeBoardView()
                    }
                }
                
                ZStack {
                    List(viewModel.freeBoardContents, id: \.priority) { data in
                        // 게시글 제목 검색 기능
                        if search == true && data.title.contains(searchTitle) {
                            NavigationLink(destination: SelectedFreeBoardView(selectedData: data)) {
                                Text("\(data.title)")
                            }
                        }
                        else if search == false || searchTitle == "" {
                            NavigationLink(destination: SelectedFreeBoardView(selectedData: data)) {
                                Text("\(data.title)")
                            }
                        }
                    }
                    .onAppear() {
                        self.viewModel.fetchData()
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct FreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: 0)))
    }
}

