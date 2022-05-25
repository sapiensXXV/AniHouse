//
//  MainCommentView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/12.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct MainCommentAddView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    @State var userNickName: String = ""
    @State var currentPost: MainPost = MainPost()
    @State var commentContent: String = ""
    @Binding var currentComments: [Comment]
    let user = Auth.auth().currentUser // 현재 유저객체

    var body: some View {
        HStack {
            TextField("댓글을 남겨보세요", text: $commentContent)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(width: 270)
                .onSubmit {
                    let newComment = Comment(email: (user?.email)!,
                                             nickName: self.userNickName,
                                             content: self.commentContent,
                                             date: Date())
                    mainFirestoreViewModel.addComment(collectionName: "MainPost",
                                                      documentId: currentPost.id,
                                                      newComment: newComment)
                    withAnimation {
                        mainFirestoreViewModel.getComment(collectionName: "MainPost", documentId: currentPost.id)
                    }
                    
                    print("comment add button pressed")
                    commentContent = ""

                }
            Button(action: {
                let newComment = Comment(email: (user?.email)!,
                                         nickName: self.userNickName,
                                         content: self.commentContent,
                                         date: Date())
                mainFirestoreViewModel.addComment(collectionName: "MainPost",
                                                  documentId: currentPost.id,
                                                  newComment: newComment)
                withAnimation {
                    mainFirestoreViewModel.getComment(collectionName: "MainPost", documentId: currentPost.id)
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

//struct MainCommentAddView_Previews: PreviewProvider {
//    static var previews: some View {
////        MainCommentAddView(, currentComments: )
//    }
//}
