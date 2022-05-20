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
    var currentCommentId: String = ""
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    var isCommentUser = false
    var documentId: String = ""
    @State var showingCommentAlert = false
    //    @Binding var currentComments: [Comment]
    @State var isVisible: Bool = false
    
    @State var showDeleteAlert: Bool = false
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    init(currentCommentId: String, nickName: String, content: String, date: Date, isCommentUser: Bool, documentId: String) {
        self.currentCommentId = currentCommentId
        self.nickName = nickName
        self.content = content
        self.date = date
        self.isCommentUser = isCommentUser
        self.documentId = documentId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(nickName!)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button(action: {
                    self.showDeleteAlert.toggle()
                }, label: {
                    Image(systemName: isCommentUser ? "trash" : "")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.red)
                        .alert(isPresented: self.$showDeleteAlert) {
                            Alert(title: Text("댓글을 삭제하시겠습니까?"), message: Text("삭제한 댓글은 복구할 수 없습니다."), primaryButton: .destructive(Text("삭제"), action: {
                                withAnimation {
                                    freeFirestoreViewModel.deleteComment(collectionName: "FreeBoard", documentId: documentId, commentId: currentCommentId)
                                }
                            }), secondaryButton: .cancel(Text("취소")))
                        }
                })
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
