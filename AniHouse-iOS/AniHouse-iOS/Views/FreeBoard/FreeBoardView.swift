//
//  FreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FreeBoardView: View {
    @State private var title = ""
    @State private var showModal = false
    @ObservedObject private var viewModel = FreeBoardViewModel()
    @Binding var selectedData: FreeBoardContent
    @State private var search = false
    @State private var searchTitle = ""

    let user = Auth.auth().currentUser
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
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(data.title)")
                                            .font(Font.headline.weight(.heavy))
                                            .font(.system(size: 13))
                                            .lineLimit(1)
                                        Spacer()
                                        Text("추천수: \(data.hit)")
                                            .font(.system(size: 11))
                                    }
                                    Text("\(data.body)")
                                        .font(.system(size: 12))
                                        .lineLimit(1)
                                }
                            }
                        }
                        else if search == false || searchTitle == "" {
                            NavigationLink(destination: SelectedFreeBoardView(selectedData: data)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(data.title)")
                                            .font(Font.headline.weight(.heavy))
                                            .font(.system(size: 13))
                                            .lineLimit(1)
                                        Spacer()
                                        Text("추천수: \(data.hit)")
                                            .font(.system(size: 11))
                                    }
                                    Text("\(data.body)")
                                        .font(.system(size: 12))
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .onAppear() {
                        self.viewModel.fetchData()
                        // FreeBoardView가 나타날 때 실행할 action
                        // HitList document 생성
                        // current user ID 이름으로 생성
                        // 이미 존재하다면 생성하지 않고 그렇지 않을 경우 생성
                        let db = Firestore.firestore()
                        let docRef = db.collection("HitList").document("\(user?.email ?? "nil")")
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                                print("Document data: \(dataDescription)")
                            } else {
                                db.collection("HitList").document("\(user?.email ?? "nil")").setData(["user":"nil"])
                                print("Document does not exist")
                            }
                        }
                        
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
        FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: "", author: "", hit:0, comment: [""], hitCheck: false)))
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
