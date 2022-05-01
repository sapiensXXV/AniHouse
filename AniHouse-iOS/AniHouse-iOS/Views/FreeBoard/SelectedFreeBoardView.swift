//
//  SelectedFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/05.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SelectedFreeBoardView: View {
    @State var selectedData: FreeBoardContent
    @State var showingAlert = false
    @State var showModal = false
    @Environment(\.presentationMode) var presentationMode
    
    @State var isLiked: Bool = false
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isLiked ? 0.7 : 1.3
    }
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // 게시글 제목
            HStack {
//                    Text("게시글 제목")
//                        .font(.system(size: 12))
//                        .padding(.bottom, 2)
//                        .foregroundColor(.gray)
                    Text(selectedData.title)
                        .padding(7)
                        .background(Color("MainViewCellColor"))
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 2, x: 0, y: 0)

                Spacer()

                Text("\(selectedData.hit)")
                    .padding(7)
                    .background(Color("MainViewCellColor"))
                    .cornerRadius(5)
                    .shadow(color: .gray, radius: 2, x: 0, y: 0)

                
                // 게시글 좋아요 버튼
                Button(action: {
                    self.animate = true
                    // 한명이 하나의 좋아요만 누를 수 있게 하기 위함
                    if selectedData.hitCheck == false {
                        selectedData.hit += 1
                        selectedData.hitCheck.toggle()
                    }
                    else {
                        selectedData.hit -= 1
                        selectedData.hitCheck.toggle()
                    }
                    let db = Firestore.firestore()
                    db.collection("FreeBoard").document(String(selectedData.priority)).setData(["title":selectedData.title,"body":selectedData.body, "priority":selectedData.priority, "author":selectedData.author, "hit":selectedData.hit, "comment":[""], "hitCheck":selectedData.hitCheck])

//                    let user = Auth.auth().currentUser
//                    db.collection("HitList").document(user?.email ?? "nil").updateData(["hitCheck":FieldValue.arrayUnion([selectedData.hitCheck]), "priority": FieldValue.arrayUnion([selectedData.priority])])
                                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                        self.animate = false
                        self.isLiked.toggle()
                    })
                }, label: {
                    Image(systemName: selectedData.hitCheck ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(selectedData.hitCheck ? .red : .gray)
                })
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading)
                    .scaleEffect(animate ? animationScale : 1)
                    .animation(Animation.easeIn(duration: animationDuration), value: animationScale)
//                    .animation(.easeIn(duration: animationDuration))

            }
            .padding()
            
            // 게시글 작성자
            VStack(alignment: .leading) {
//                Text("작성자")
//                    .font(.system(size: 12))
//                    .padding(.bottom, 2)
//                    .foregroundColor(.gray)
                Text(selectedData.author)
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
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct SelectedFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedFreeBoardView(selectedData: .init(title: "", body: "", priority: 0, author: "", hit:0, comment: [""], hitCheck: false))
    }
}
