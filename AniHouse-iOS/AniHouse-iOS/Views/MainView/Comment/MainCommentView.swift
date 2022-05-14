//
//  MainCommentView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/12.
//

import SwiftUI

struct MainCommentView: View {
    
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    
    var nickName: String?
    var content: String?
    var date: Date?
    var currentCommentId: String = ""
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    var isCommentUser = false
    var documentId: String = ""
    
    @State var showDeleteAlert: Bool = false
    
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
            Rectangle().frame(height: 0)
            HStack{
                
                Image(systemName: "person")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.orange)
                    )
                VStack(alignment: .leading) {
                    Text(nickName!)
                        .fontWeight(.semibold)
                    Text(dateString)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Button {
                    self.showDeleteAlert.toggle()
                } label: {
                    Image(systemName: isCommentUser ? "trash" : "")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
                .padding(0)
                .alert(isPresented: self.$showDeleteAlert) {
                    Alert(title: Text("댓글을 삭제하시겠습니까?"), message: Text("삭제한 댓글은 복구할 수 없습니다."), primaryButton: .destructive(Text("삭제"), action: {
                        withAnimation {
                            mainFirestoreViewModel.deleteComment(collectionName: "MainPost", documentId: documentId, commentId: currentCommentId)
                        }
                    }), secondaryButton: .cancel(Text("취소")))
                }

                
            }
            Text(content!)
                .fontWeight(.light)
                .padding(.leading, 5)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background(Color(Constant.CustomColor.muchLightBrown))
        .cornerRadius(5)
        .onAppear {
            self.formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
            self.dateString = formatter.string(from: self.date!)
            print("asdf: \(self.isCommentUser)")
            //                print("currentComment.email = \(currentComment.email)")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
//                print("userInfoManager.user!.email = \(userInfoManager.user!.email!)")
//                print("currentComment.email = \(currentComment.email)")
//                if userInfoManager.user!.email == currentComment.email {
//                    self.isCommentUser = true
//                }
//            })
            print("MainCommentView - currentComment.id = \(currentCommentId)")
            
        }
    }
}

struct MainCommentView_Previews: PreviewProvider {
    static var previews: some View {
        MainCommentView(currentCommentId: "", nickName: "소재훈", content: "댓글입니다~~", date: Date(), isCommentUser: false, documentId: "")
    }
}
