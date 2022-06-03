//
//  FreeCommentView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/05/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct FreeCommentView: View {
    var email:  String?
    var nickName: String?
    var content: String?
    var date: Date?
    var currentCommentId: String = ""
    
    var isCommentUser = false
    var documentId: String = ""
    var isBlockedUser: Bool = false
    //    @Binding var currentComments: [Comment]
    @State var isVisible: Bool = false
    @State var showingCommentAlert = false
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    @State var showDeleteAlert: Bool = false
    
    
    @State var commentProfileImage: UIImage? = nil
    
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    init(email: String, currentCommentId: String, nickName: String, content: String, date: Date, isCommentUser: Bool, documentId: String, isBlockedUser: Bool) {
        self.email = email
        self.currentCommentId = currentCommentId
        self.nickName = nickName
        self.content = content
        self.date = date
        self.isCommentUser = isCommentUser
        self.documentId = documentId
        self.isBlockedUser = isBlockedUser
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let commentProfileImage = commentProfileImage {
                    Image(uiImage: commentProfileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(lineWidth: 1)
                        )
                } else {
                    Image(Constant.ImageName.defaultUserImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(lineWidth: 1)
                        )
                }
                VStack(alignment: .leading) {
                    Text(!isBlockedUser ? nickName! : "차단된 사용자")
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(dateString)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
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
                    .disabled(isCommentUser ? false : true)
            }
            .padding([.top, .horizontal], 5)
            Text(!isBlockedUser ? content! : "차단된 사용자입니다")
            // 댓글의 내용이 전부 보여야 하기 때문
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 5)
        }
        .padding(.leading,5)
        .padding(.trailing,5)
        .padding(.bottom, 5)
        .background(Color(Constant.CustomColor.muchLightBrown))
        .cornerRadius(5)
        .onAppear {
            self.formatter.dateFormat = "yy/MM/dd HH:mm"
            self.dateString = formatter.string(from: self.date!)
            getProfileImage()
        }
    }
    func getProfileImage() {
        let storage = Storage.storage()
        let profileImageRef = storage.reference().child("user/profileImage/\(email!)")
        profileImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SelectedMainPost - \(email!) 의 프로필사진을 찾았습니다!")
                DispatchQueue.main.async {
                    self.commentProfileImage = UIImage(data: data!)!
                }
                
            }
        }
    }
}

//struct FreeCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FreeCommentView()
//    }
//}
