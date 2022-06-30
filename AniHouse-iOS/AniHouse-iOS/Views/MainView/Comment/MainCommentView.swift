//
//  MainCommentView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/12.
//

import SwiftUI
import FirebaseStorage

struct MainCommentView: View {
    
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    
    @State var profileImage: UIImage? = nil
    
    var email: String?
    var nickName: String?
    var content: String?
    var date: Date?
    var currentCommentId: String = ""
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    var isCommentUser = false
    var documentId: String = ""
    var isBlockedUser: Bool = false
    
    @State var showDeleteAlert: Bool = false
    @State var showReportAlert: Bool = false
    
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
            Rectangle().frame(height: 0)
            HStack{
                
                if profileImage == nil {
                    Image(systemName: "person")
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 1)

                        )
                } else {
                    Image(uiImage: profileImage!)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading) {
                    Text(!isBlockedUser ? nickName! : "차단된 사용자")
                        .fontWeight(.semibold)
                    Text(dateString)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Button {
                    self.showDeleteAlert = true
                } label: {
                    Image(systemName: isCommentUser ? "trash" : "")
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                }
                .padding(0)
                .alert(isPresented: self.$showDeleteAlert) {
                    Alert(title: Text("댓글을 삭제하시겠습니까?"), message: Text("삭제한 댓글은 복구할 수 없습니다."), primaryButton: .destructive(Text("삭제"), action: {
                        withAnimation {
                            mainFirestoreViewModel.deleteComment(collectionName: "MainPost", documentId: documentId, commentId: currentCommentId)
                        }
                    }), secondaryButton: .cancel(Text("취소")))
                }
                Spacer()
                    .frame(width: 12)
                Button {
                    self.showReportAlert = true
                } label: {
                    Image(systemName: "flag")
                }
                .alert(isPresented: self.$showReportAlert) {
                    Alert(title: Text("댓글을 신고하시겠습니까?"), message: Text("신고된 댓글은 확인 후 조치됩니다."),
                          primaryButton: .destructive(Text("신고"), action: {
                        withAnimation {
                            print("신고버튼이 눌렸어요!")
                        }
                    }),secondaryButton: .cancel(Text("취소")))
                }
            }
            Text(!isBlockedUser ? content! : "차단된 사용자 입니다")
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
            print("MainCommentView - currentComment.id = \(currentCommentId)")
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
                print("\(email!) 의 프로필사진을 찾았습니다!")
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: data!)!
                }
                
            }
            
        }
        
    }
    
}

struct MainCommentView_Previews: PreviewProvider {
    static var previews: some View {
        MainCommentView(email: "", currentCommentId: "", nickName: "소재훈", content: "댓글입니다~~", date: Date(), isCommentUser: false, documentId: "", isBlockedUser: false)
    }
}
