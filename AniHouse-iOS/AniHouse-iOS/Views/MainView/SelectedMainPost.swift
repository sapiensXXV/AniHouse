//
//  SelectedMainPost.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/07.
//

import SwiftUI
import Firebase

struct SelectedMainPost: View {
    
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    //작성자의 프로필사진
    @State var writerProfileImage: UIImage? = nil
    @State var writerNickName: String? = nil
    
    @State var image: UIImage? = nil
    
    @State var post: MainPost = MainPost() // 게시글 객체를 넘겨받음.
    @State var hitValue: Int = 0 // 현재 좋아요 개수
    
    @State private var animate = false // 애니매이션 동작여부
    @State var isLiked: Bool = false // 현재 유저가 좋아요를 체크했는지 여부
    @State var dateString: String = ""
    @State var idGetComment: Bool = false
    @State var currentComments: [Comment] = [Comment]()
    @State var userNickName: String = ""
    
    //알림여부
    @State var showPostDeleteButton: Bool = false
    @State var showAlert: Bool = false
    @State var showDeleteAlert: Bool = false
    @State var showReportAlert: Bool = false
    @State var showBlockAlert: Bool = false
    
    @State var formatter: DateFormatter = DateFormatter()
    
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        self.isLiked ? 0.7 : 1.3
    }
    
    @State var url = ""
    
    var body: some View {
        VStack(spacing: 1) {
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Spacer().frame(height: 10)
                    Rectangle().frame(height: 0)
                    
                    //                    Spacer().frame(height: 3)
                    HStack() {
                        if writerProfileImage == nil {
                            Image(Constant.ImageName.defaultUserImage)
                                .resizable()
                            //                        .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                                .background(Color(Constant.CustomColor.muchLightBrown))
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(lineWidth: 1)
                                )
                        }
                        else {
                            Image(uiImage: writerProfileImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(lineWidth: 1)
                                )
                        }
                        if writerNickName == nil {
                            Text("nickName")
                                .fontWeight(.semibold)
                        } else {
                            Text(self.writerNickName!)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.top, 3)
                    //                    Rectangle().frame(height: 0)
                    //MARK: - 수정
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(3)
                    } else {
                        Image(Constant.ImageName.defaultImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(3)
                    }
                    HStack {
                        Button {
                            //action
                            if isLiked {
                                /// 게시글의 좋아요를 누른 상태일 때 Like를 지운다.
                                //                                DispatchQueue.main.async {
                                mainFirestoreViewModel.deleteLike(post: self.post, currentUser: self.userInfoManager.user?.email! ?? "")
                                //                                }
                                self.isLiked.toggle()
                                hitValue -= 1
                            } else {
                                /// 좋아요를 누르지 않은 상태일 때
                                //                                DispatchQueue.main.async {
                                mainFirestoreViewModel.addLike(post: self.post, currentUser: self.userInfoManager.user?.email! ?? "")
                                
                                //                                }
                                self.isLiked.toggle()
                                hitValue += 1
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                                self.animate = false
                            })
                        } label: {
                            Image(systemName: self.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(self.isLiked ? .red : .gray)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 3)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.leading)
                        .scaleEffect(animate ? animationScale : 1)
                        .animation(Animation.easeIn(duration: animationDuration), value: animationScale)
                        Text("\(self.hitValue)")
                            .padding(.leading, 3)
                        Spacer()
                    }
                    Text("\(post.body)")
                        .font(.system(size: 16))
                        .padding(.top, 3)
                        .padding(.horizontal)
                        .lineSpacing(3)
                    Text(self.dateString)
                        .foregroundColor(.secondary)
                        .font(.system(size: 11))
                        .padding(.top, 3)
                        .padding([.leading, .trailing])
                    //                    MainCommentAddView(currentPost: self.post)
                    ForEach(self.mainFirestoreViewModel.comments.indices, id: \.self.hashValue) { idx in
                        MainCommentView(email: mainFirestoreViewModel.comments[idx].email,
                                        currentCommentId: mainFirestoreViewModel.comments[idx].id,
                                        nickName: mainFirestoreViewModel.comments[idx].nickName,
                                        content: mainFirestoreViewModel.comments[idx].content,
                                        date: mainFirestoreViewModel.comments[idx].date,
                                        isCommentUser: userInfoManager.user?.email! == mainFirestoreViewModel.comments[idx].email,
                                        documentId: self.post.id,
                                        isBlockedUser: userInfoManager.userBlockList.contains(mainFirestoreViewModel.comments[idx].email))
                            .padding(.horizontal, 3)
                            .onAppear {
                                
                                //                                print("user!.email! = \(userInfoManager.user?.email!)")
                                //                                print("currentComment[\(idx)].id = \(mainFirestoreViewModel.comments[idx].id)")
                                //                                print(userInfoManager.user?.email == mainFirestoreViewModel.comments[idx].email)
                            }
                        
                    }
                    Spacer()
                }
                .onAppear {
                    self.hitValue = post.hit
                    if post.likeUsers.contains(userInfoManager.user?.email! ?? "") {
                        isLiked = true
                    } else {
                        isLiked = false
                    }
                    
                    self.formatter = DateFormatter()
                    self.formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
                    //                    print("post.date = \(post.date)")
                    dateString = self.formatter.string(from: self.post.date)
                    
                }
            }
            .onAppear {
                mainFirestoreViewModel.getComment(collectionName: "MainPost", documentId: self.post.id)
                print("model.comments: \(mainFirestoreViewModel.comments)")
                for comment in mainFirestoreViewModel.comments {
                    self.currentComments.append(comment)
                }
                if userInfoManager.user?.email! == post.author {
                    self.showPostDeleteButton = true
                }
                getProfileImage()
                getWriterNickName()
                loadMainImage(imageName: self.post.id)
                
            }
            MainCommentAddView(currentPost: self.post, currentComments: self.$currentComments)
                .padding(.horizontal, 5)
                .padding(.bottom, 5)
        } // VStack
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            //MARK: - 게시글 삭제기능
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    if self.showPostDeleteButton {
                        Button {
                            // 삭제 @State값을 토글한다.
                            self.showAlert = true
                            self.showDeleteAlert = true
                            print("게시글 삭제 버튼 pressed")
                        } label: {
                            Label("삭제하기", systemImage: "trash")

                        }
                    } else {
                        Button {
                            self.showAlert = true
                            self.showReportAlert = true
                            self.showDeleteAlert = false
                            self.showBlockAlert = false
                            print("신고누름")
                        } label: {
                            Label("신고하기", systemImage: "flag")
                        }
                        Button {
                            self.showAlert = true
                            self.showBlockAlert = true
                            self.showDeleteAlert = false
                            self.showReportAlert = false
                            print("차단 누름")
                        } label: {
                            Label("이 유저 차단하기", systemImage: "nosign")
                        }
                    }
                    
                } label: {
                    Image(Constant.ImageName.dots)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .menuStyle(.automatic)
                .alert(isPresented: $showAlert) {
                    if showReportAlert {
                        return Alert(title: Text("신고"), message: Text("부적절한 내용 발견시 삭제조치됩니다"), primaryButton: .default(Text("신고하기"), action: {
                            mainFirestoreViewModel.reportMainPost(postId: post.id)
                        }), secondaryButton: .destructive(Text("취소")))
                    }
                    else if showDeleteAlert {
                        return Alert(title: Text("게시글을 삭제하시겠습니까?"),
                                     message: Text("삭제한 게시글은 복구할 수 없습니다"),
                                     primaryButton: .destructive(Text("삭제"), action: {
                            mainFirestoreViewModel.deletePost(postId: self.post.id)
                        }),
                                     secondaryButton: .cancel(Text("취소")))
                    }
                    return Alert(title: Text("이 유저를 차단하시겠습니까?"),
                                 message: Text("차단 후에는 이 유저가 쓴 글과 댓글이 보이지 않습니다"),
                                 primaryButton: .destructive(Text("차단"), action: {
                        print("차단버튼을 눌렀어요")
                        userInfoManager.addBlockUser(blockEmail: post.author)
                        presentationMode.wrappedValue.dismiss() // 이전 화면으로 돌아감.
                    }), secondaryButton: .default(Text("아니오")))
                }
            } // ToolBarItemGroup
        }
        .background(Color(Constant.CustomColor.lightBrown))
    }
    
    func loadMainImage(imageName: String) {
        let storage = Storage.storage()
        let mainImageRef = storage.reference().child("MainPostImage/\(imageName).jpg")
        mainImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("메인 사진을 찾았습니다.")
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func getProfileImage() {
        let storage = Storage.storage()
        let profileImageRef = storage.reference().child("user/profileImage/\(post.author)")
        profileImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SelectedMainPost - \(post.author) 의 프로필사진을 찾았습니다!")
                DispatchQueue.main.async {
                    self.writerProfileImage = UIImage(data: data!)!
                }
                
            }
        }
    }
    func getWriterNickName() {
        let db = Firestore.firestore()
        print("SelectedMainPost - getWriterNickName - \(post.author)")
        db.collection("userInfo").document(post.author).getDocument { snapshot, error in
            if let snapshot = snapshot {
                self.writerNickName = snapshot.get("nickName") as? String
                print("게시글 작성자의 닉네임을 가져왔어요! -> \(writerNickName)")
            }
        }
    }
}

struct SelectedMainPost_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMainPost(post: MainPost())
    }
}
