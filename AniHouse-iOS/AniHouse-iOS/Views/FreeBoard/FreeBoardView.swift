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
    @State private var isPresented = true
    
    let user = Auth.auth().currentUser
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        TextField("게시글 제목을 검색하세요", text: $title)
                            .font(Font.custom("KoreanSDNR-B", size: 18))
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
                
                ZStack {
                    List(viewModel.freeBoardContents, id: \.priority) { data in
                        // 게시글 제목 검색 기능
                        if search == true && data.title.contains(searchTitle) {
                            ZStack {
                                NavigationLink(destination: SelectedFreeBoardView(selectedData: data, showingOverlay: $isPresented)) {
                                    EmptyView()
                                }
                                .opacity(0.0)
                                .buttonStyle(PlainButtonStyle())
                                ZStack {
                                    Color.white
                                        .cornerRadius(12)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(data.title)")
                                                .font(Font.custom("KoreanSDNR-B", size: 18))
                                                .lineLimit(1)
                                            Spacer()
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 11, height: 11)
                                                .foregroundColor(.red)
                                            Text("\(data.hit)")
                                                .font(Font.custom("KoreanSDNR-M", size: 13))
                                                .lineLimit(1)
                                        }
                                        Text("\(data.body)")
                                            .font(Font.custom("KoreanSDNR-M", size: 13))
                                            .lineLimit(1)
                                    }
                                    .padding()
                                }
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                .listRowSeparator(.hidden)
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            .listRowSeparator(.hidden)
                            
                        }
                        else if search == false || searchTitle == "" {
                            ZStack {
                                NavigationLink(destination: SelectedFreeBoardView(selectedData: data, showingOverlay: $isPresented)) {
                                    EmptyView()
                                }
                                // arrow 없애기 위해
                                .opacity(0.0)
                                .buttonStyle(PlainButtonStyle())
                                ZStack {
                                    Color.white
                                        .cornerRadius(12)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            //                                            폰트명: KoreanSDNR-B, KoreanSDNR-M
                                            Text("\(data.title)")
                                            //                                                .font(.system(size: 25))
                                                .font(Font.custom("KoreanSDNR-B", size: 18))
                                                .lineLimit(1)
                                            Spacer()
                                            Image(systemName: "heart.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 11, height: 11)
                                                .foregroundColor(.red)
                                            Text("\(data.hit)")
                                                .font(Font.custom("KoreanSDNR-M", size: 13))
                                                .lineLimit(1)
                                        }
                                        Text("\(data.body)")
                                            .font(Font.custom("KoreanSDNR-M", size: 13))
                                            .lineLimit(1)
                                    }
                                    .padding()
                                }
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                .listRowSeparator(.hidden)  // 분리선 없애기 위해
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            .listRowSeparator(.hidden)
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onAppear() {
                        isPresented = true
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
        .overlay(
            alertView
            ,alignment: .bottom
        )
    }
    @ViewBuilder
    private var alertView: some View {
        if isPresented {
            Button(action: {
                showModal = true
            }) {
                HStack {
                    Image("pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                    Text("글 쓰기")
                        .font(Font.custom("KoreanSDNR-B", size: 15))
                }
                .frame(width: 100, height: 20)
                .padding()
            }
                .foregroundColor(.black)
                .background(Color("board-add-button"))
                .cornerRadius(.infinity)
                .padding(5)
            // 게시글 추가 Modal View
            .sheet(isPresented: self.$showModal) {
                AddFreeBoardView()
            }
        }
    }
}

struct FreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: "", author: "", hit:0, hitCheck: false)))
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
