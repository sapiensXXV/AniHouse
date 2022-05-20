//
//  FreeAddCommentView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/05/12.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct FreeAddCommentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    @State var userNickName: String = ""
    @State var currentPost: FreeBoardContent = FreeBoardContent()
    @State var commentContent: String = ""
    @Binding var currentComments: [Comment]
    let user = Auth.auth().currentUser // 현재 유저객체
    var body: some View {
        HStack {
            TextField("", text: $commentContent)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(width: 270)
            Button(action: {
                let newComment = Comment(email: (user?.email)!,
                                         nickName: self.userNickName,
                                         content: self.commentContent,
                                         date: Date())
                freeFirestoreViewModel.addComment(collectionName: "FreeBoard",
                                                  documentId: currentPost.id,
                                                  newComment: newComment)
                withAnimation {
                    freeFirestoreViewModel.getComment(collectionName: "FreeBoard", documentId: currentPost.id)
                }
                
                print("comment add button pressed")
                commentContent = ""
            }, label: {
                Image(systemName: "paperplane")
            })
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(12)
        .onAppear {
            self.userNickName = userInfoManager.userNickName
            if self.userNickName == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.userNickName = userInfoManager.userNickName
                    print("userInfoManager.userNickName: \(userInfoManager.userNickName)")
                }
            }
        }
        
        
    }
}

//struct FreeAddCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FreeAddCommentView()
//    }
//}








//HStack {
//    TextField("", text: $commentField)
//        .disableAutocorrection(true)
//        .autocapitalization(.none)
//        .frame(width: 270)
//    Button(action: {
//        let comment = Comment(email: user?.email ?? "nil", nickName: "defaultNickName", content: commentField, date: Date())
//        model.addComment(collectionName: "FreeBoard", documentId: String(selectedData.priority), newComment: comment)
//        print(selectedData.priority)
//        // 댓글을 달았으므로 내용 삭제
//        commentField = ""
//        currentComments.append(comment)
////                print("@@@")
////                model.getComment(collectionName: "FreeBoard", documentId: selectedData.priority)
//    }, label: {
//        Image(systemName: "paperplane")
//    })
//}
