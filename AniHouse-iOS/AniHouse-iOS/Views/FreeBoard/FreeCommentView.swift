//
//  FreeCommentView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/05/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct FreeCommentView: View {
    var nickName: String?
    var content: String?
    var date: Date?
    var id: String // 삭제하고 싶은 댓글의 id를 알기 위해서
    var idx: Int
    var email: String
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    @State var showingCommentAlert = false
    @State var selectedData: FreeBoardContent
//    @Binding var currentComments: [Comment]
    @State var isVisible: Bool = false

    let user = Auth.auth().currentUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(nickName!)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button(action: {
                    showingCommentAlert = true
                }, label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.red)
                        .alert("삭제하시겠습니까?", isPresented: $showingCommentAlert) {
                            Button("삭제", role: .destructive) {
                                let db = Firestore.firestore()
                                db.collection("FreeBoard").document(String(selectedData.priority)).collection("comment").document(id).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        // 아이패드에 적어놓은 오류 2가지 여전히 존재
                                        // 애초에 addComment를 할 때 document()를 하는 것이 아니라 document의 이름을 정해놓자.
//                                        currentComments.remove(at: idx)
                                    }
                                }
                                print("현재 선택한 댓글 id: \(id)")
                            }
                            Button("취소", role: .cancel) {
                            }
                        }
                })
                .opacity(isVisible ? 1 : 0)
            }
            // 본인이 작성한 댓글만 삭제할 수 있어야 하므로
            // 현재 로그인한 계정과 작성한 댓글의 계정이 동일한지 판단
            .onAppear {
                if user?.email! == email {
                        isVisible = true
                } else {
                    isVisible = false
                }
            }
            Text(content!)
            // 댓글의 내용이 전부 보여야 하기 때문
                .fixedSize(horizontal: false, vertical: true)
            Text(dateString)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(.leading,5)
        .padding(.trailing,5)
        .padding(.bottom, 5)
        .onAppear {
            self.formatter.dateFormat = "yy/MM/dd HH:mm"
            self.dateString = formatter.string(from: self.date!)
        }
    }
}

//struct FreeCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FreeCommentView()
//    }
//}
