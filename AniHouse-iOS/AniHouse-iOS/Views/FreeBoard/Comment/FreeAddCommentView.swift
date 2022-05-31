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
    @State var isValidComment: Bool = true
    @State var showForbidWordAlert: Bool = false
    
    @Binding var currentComments: [Comment]
    let user = Auth.auth().currentUser // 현재 유저객체
    var body: some View {
        HStack {
            TextField(isValidComment ? "댓글을 남겨보세요" : "댓글은 한 글자 이상이어야 합니다", text: $commentContent)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(width: nil)
            Button(action: {
                if isForbidWordComment() {
                    showForbidWordAlert.toggle()
                }
                else if commentContent != "" {
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
                } else {
                    isValidComment = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isValidComment = true
                    }
                }
            }, label: {
                Image(systemName: "paperplane")
            })
                .alert(isPresented: $showForbidWordAlert) {
                    Alert(title: Text("상처주는 표현이 포함되어 있지 않나요?"), message: Text("부적절한 표현이 감지됩니다. 반복 등록시 이용이 제한될 수 있습니다."), dismissButton: .destructive(Text("알겠습니다")))
                }
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
    func isForbidWordComment() -> Bool {
        for word in Constant.forbidWord {
            if commentContent.contains(word) { return true }
        }
        return false
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
