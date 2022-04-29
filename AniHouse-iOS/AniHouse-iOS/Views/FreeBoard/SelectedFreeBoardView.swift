//
//  SelectedFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/05.
//

import SwiftUI
import FirebaseFirestore

struct SelectedFreeBoardView: View {
    @State var selectedData: FreeBoardContent
    @State var showingAlert = false
    @State var showModal = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            // 게시글 제목
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
//                    Text("게시글 제목")
//                        .font(.system(size: 12))
//                        .padding(.bottom, 2)
//                        .foregroundColor(.gray)
                    Text(selectedData.title)
                        .padding(7)
                        .background(Color("MainViewCellColor"))
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 2, x: 0, y: 0)
                }
                                
                Spacer()
                
                // 게시글 좋아요 버튼
                Button(action: {
                    
                }, label: {
                    Image("like")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading)

            }
            .padding()
            
            // 게시글 작성자
            VStack(alignment: .leading) {
//                Text("작성자")
//                    .font(.system(size: 12))
//                    .padding(.bottom, 2)
//                    .foregroundColor(.gray)
                Text("작성자")
                    .padding(7)
                    .background(Color("MainViewCellColor"))
                    .cornerRadius(5)
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)

            }
            .padding()

            // 게시글 내용
            VStack(alignment: .leading) {
//                Text("게시글 내용")
//                    .font(.system(size: 12))
//                    .padding(.bottom, 2)
//                    .foregroundColor(.gray)
                Text(selectedData.body)
                    .padding(7)
                    .background(Color("MainViewCellColor"))
                    .cornerRadius(5)
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)
            }
            .padding()
            
            // 게시글 삭제, 수정
            VStack {
                // 게시글 삭제 기능
                Button(action: {
                    showingAlert = true
                }, label: {
                    Text("게시글 삭제")
                        .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
                            Button("삭제", role: .destructive) {
                                let db = Firestore.firestore()
                                db.collection("FreeBoard").document(String(selectedData.priority)).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                    }
                                }
                            }
                            Button("취소", role: .cancel) {
                                
                            }
                        }
                })
                    .buttonStyle(BorderlessButtonStyle())
                
//                Spacer()
                                    
                // 게시글 수정 기능
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    showModal = true
                }, label: {
                    Text("게시글 수정")
                })
                    .buttonStyle(BorderlessButtonStyle())     .sheet(isPresented: self.$showModal) {
                        ReviseFreeBoardView(selectedData: selectedData)
                    }

            }
            .padding()

            Spacer()

        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
//        VStack {
//            // 추후 사용자 이름도 가져올 예정
//            Form {
//                Section(header: Text("게시글 제목").fontWeight(.heavy)) {
//                    HStack {
//                        ZStack {
//                            Text(selectedData.title)
//                        }
//
//                    }
//
//                }
//
//                Section(header: Text("작성자").fontWeight(.heavy)) {
//                    // login view 연결 시 사용자 정보 가져올 예정
//                    Text("작성자")
//                }
//
//                Section(header: Text("게시글 내용").fontWeight(.heavy)) {
//                    Text(selectedData.body)
//                        .frame(height: 300, alignment: .top)
//                }
//
//                Section {
//                    HStack(alignment: .center) {
//                        Spacer()
//                        Text("이 게시글을 추천합니다.")
//                        Button(action: {
//
//                        }, label: {
//                            Image("like")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                        })
//                            .buttonStyle(BorderlessButtonStyle())
//                        Spacer()
//                    }
//                }
//
//                HStack {
//                    Spacer()
//                    // 게시글 삭제 기능
//                    Button(action: {
//                        showingAlert = true
//                    }, label: {
//                        Text("게시글 삭제")
//                            .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
//                                Button("삭제", role: .destructive) {
//                                    let db = Firestore.firestore()
//                                    db.collection("FreeBoard").document(String(selectedData.priority)).delete() { err in
//                                        if let err = err {
//                                            print("Error removing document: \(err)")
//                                        } else {
//                                            print("Document successfully removed!")
//                                        }
//                                    }
//                                }
//                                Button("취소", role: .cancel) {
//
//                                }
//                            }
//                    })
//                        .buttonStyle(BorderlessButtonStyle())
//
//                    Spacer()
//
//                    // 게시글 수정 기능
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                        showModal = true
//                    }, label: {
//                        Text("게시글 수정")
//                    })
//                        .buttonStyle(BorderlessButtonStyle())     .sheet(isPresented: self.$showModal) {
//                            ReviseFreeBoardView(selectedData: selectedData)
//                        }
//                    Spacer()
//                }
//            }
//        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct SelectedFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedFreeBoardView(selectedData: .init(title: "", body: "", priority: 0, author: "", hit:0, comment: [""], hitCheck: false))
    }
}
