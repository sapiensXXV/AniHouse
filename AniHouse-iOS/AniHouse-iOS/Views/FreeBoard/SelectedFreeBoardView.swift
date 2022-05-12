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
    
    let user = Auth.auth().currentUser
    
    @State var isLiked: Bool = false
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isLiked ? 0.7 : 1.3
    }
    @State private var animate = false
    
    @State private var isPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // 게시글 제목
            HStack {
                Text(selectedData.title)
                    .font(Font.custom("KoreanSDNR-B", size: 20))
                
                Spacer()
                
                // 게시글 좋아요 버튼
                Button(action: {
                    let db = Firestore.firestore()
                    self.animate = true
                    // 한명이 하나의 좋아요만 누를 수 있게 하기 위함
                    if selectedData.hitCheck == false {
                        selectedData.hit += 1
                        selectedData.hitCheck.toggle()
                        // 현재 보고 있는 게시글이 current user ID 이름의 document의 배열에
                        // 존재하지 않으니 아직 좋아요를 눌렀지 않았다는 의미이므로 배열에 해당 게시글을 추가
                        db.collection("HitList").document("\(user?.email ?? "nil")").updateData(["user":FieldValue.arrayUnion([selectedData.priority])])
                    }
                    else {
                        selectedData.hit -= 1
                        selectedData.hitCheck.toggle()
                        // document의 배열에 이미 존재하니까 이미 좋아요를 누른 상태에서 한번 더 누르면 좋아요를 하지 않는다는 의미이므로 배열에서 해당 게시글을 삭제
                        db.collection("HitList").document("\(user?.email ?? "nil")").updateData(["user":FieldValue.arrayRemove([selectedData.priority])])
                    }
                    db.collection("FreeBoard").document(String(selectedData.priority)).setData(["title":selectedData.title,"body":selectedData.body, "priority":selectedData.priority, "author":selectedData.author, "hit":selectedData.hit, "comment":[""], "hitCheck":selectedData.hitCheck])
                    
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
                
                Text("\(selectedData.hit)")
                    .font(Font.custom("KoreanSDNR-M", size: 13))
                
            }
            .padding()
            .onAppear(perform: {
                // 게시글을 눌렀을 때의 View가 SelectedFreeBoardView이다.
                // 현재 있는 View의 하트가 빈 하트인지, 색칠된 하트인지 구별하기 위해서
                // HitList에 current user ID document가 없을 경우 -> 빈 하트
                // 그렇지 않는 경우 중에서 해당 document의 array field에 해당 게시글이 있을 경우 -> 색칠된 하트
                // 그 이외 -> 빈 하트
                let db = Firestore.firestore()
                
                let docRef = db.collection("HitList").document("\(user?.email ?? "nil")")
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        if let arr = document["user"] as? Array<String> {
                            if arr.contains(selectedData.priority) {
                                selectedData.hitCheck = true
                                print("====================")
                                print(arr)
                            }
                            else {
                                selectedData.hitCheck = false
                            }
                        }
                        else {
                            selectedData.hitCheck = false
                        }
                        
                    } else {
                        selectedData.hitCheck = false
                        print("Document does not exist")
                    }
                }
            })
            
            // 게시글 작성자
            VStack(alignment: .leading) {
                Text(selectedData.author)
                    .font(Font.custom("KoreanSDNR-M", size: 13))
            }
            .padding([.leading, .trailing])
            
            // 구분선
            Divider()
            
            // 게시글 내용
            VStack(alignment: .leading) {
                Text(selectedData.body)
                    .font(Font.custom("KoreanSDNR-M", size: 15))
            }
            .padding()
            
            // 구분선
            Divider()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .navigationBarTitleDisplayMode(.inline)
        // dots 클릭 시, 게시글 삭제 버튼과 수정 버튼 표시
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image("dots")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
            }
        }
        .overlay (
            editView
            ,alignment: .topTrailing
        )
        //        .navigationTitle("")
        //        .navigationBarHidden(true)
    }
    @ViewBuilder
    private var editView: some View {
        if isPresented {
            VStack {
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
                .padding(.bottom, 3)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    showModal = true
                }, label: {
                    Text("게시글 수정")
                })
                .buttonStyle(BorderlessButtonStyle())
                .sheet(isPresented: self.$showModal) {
                    ReviseFreeBoardView(selectedData: selectedData)
                }
            }
            .padding(.trailing)
        }
    }
    
}

struct SelectedFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedFreeBoardView(selectedData: .init(title: "", body: "", priority: "", author: "", hit:0, comment: [""], hitCheck: false))
    }
}

