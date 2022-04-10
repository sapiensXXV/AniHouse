//
//  SelectedFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/05.
//

import SwiftUI
import FirebaseFirestore

struct SelectedFreeBoardView: View {
//    @State var selectedTitle = ""
//    @State var selectedBody = ""
    @State var selectedData: FreeBoardContent
    @State var showingAlert = false
    @State var showModal = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // 추후 사용자 이름도 가져올 예정
            Text("게시글 제목: \(selectedData.title)")
                .padding()
            Text("게시글 내용: \(selectedData.body)")
                .padding()
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
                .padding()
            // 게시글 수정 기능
            Button(action: {
//                let db = Firestore.firestore()
//                db.collection("FreeBoard").document(String(selectedData.priority)).setData(["title":"수정된 제목","body":"수정된 내용", "priority":selectedData.priority])
                presentationMode.wrappedValue.dismiss()
                showModal = true
            }, label: {
                Text("게시글 수정")
            })
                .sheet(isPresented: self.$showModal) {
                    ReviseFreeBoardView(selectedData: selectedData)
                }
        }
    }
}

struct SelectedFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedFreeBoardView(selectedData: .init(title: "", body: "", priority: 0))
    }
}
