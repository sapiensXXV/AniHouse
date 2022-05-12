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
    
    @ObservedObject var storeManager = MainPostViewModel()
    
    @State var currentPost: MainPost = MainPost()
    @State var commentContent: String = ""
    let user = Auth.auth().currentUser // 현재 유저객체

    var body: some View {
        HStack {
            TextField("댓글을 입력하세요", text: $commentContent)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.none)
                .padding()
            Spacer()
            Button {
                storeManager.addComment(collectionName: "MainPost",
                                        documentId: currentPost.id,
                                        newComment: Comment(email: (user?.email)!,
                                                            nickName: "defaultNickName",
                                                            content: self.commentContent,
                                                            date: Date()))
                storeManager.getComment(collectionName: "MainPsot", documentId: currentPost.id)
                print("comment add button pressed")
            } label: {
                Text("등록")
                    .foregroundColor(Color.white)
                    .padding(11)
                    .background(Color.blue)
                    .cornerRadius(6)
                
            }
            .padding(.trailing, 5)

        }
        .background(Color(Constant.ButtonColor.lightGray))
        .cornerRadius(6)
    }
}

struct MainCommentAddView_Previews: PreviewProvider {
    static var previews: some View {
        MainCommentAddView()
    }
}
