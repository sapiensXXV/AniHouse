//
//  SelectedMainPost.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/07.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct SelectedMainPost: View {
    
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
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
    @State var showDeleteAlert: Bool = false
    
    @State var formatter: DateFormatter = DateFormatter()
    
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        self.isLiked ? 0.7 : 1.3
    }
    
    let user = Auth.auth().currentUser // 현재 유저객체
    @State var url = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 10)
                    Rectangle().frame(height: 0)
                    if url != "" {
                        AnimatedImage(url: URL(string: url)!)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                    } else {
                        Loader()
                    }
                    HStack {
                        Button {
                            //action
                            if isLiked {
                                /// 게시글의 좋아요를 누른 상태일 때 Like를 지운다.
//                                DispatchQueue.main.async {
                                mainFirestoreViewModel.deleteLike(post: self.post, currentUser: self.user?.email ?? "")
//                                }
                                self.isLiked.toggle()
                                hitValue -= 1
                            } else {
                                /// 좋아요를 누르지 않은 상태일 때
//                                DispatchQueue.main.async {
                                mainFirestoreViewModel.addLike(post: self.post, currentUser: self.user?.email ?? "")
                                    
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
                    
                    Text("\(post.title)")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding(5)
                    Text("\(post.body)")
                        .font(.system(size: 16))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .lineSpacing(3)
                    Text(self.dateString)
                        .foregroundColor(.secondary)
                        .font(.system(size: 11))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
//                    MainCommentAddView(currentPost: self.post)
                    ForEach(self.mainFirestoreViewModel.comments.indices, id: \.self.hashValue) { idx in
                        MainCommentView(currentCommentId: mainFirestoreViewModel.comments[idx].id,
                                        nickName: mainFirestoreViewModel.comments[idx].nickName,
                                        content: mainFirestoreViewModel.comments[idx].content,
                                        date: mainFirestoreViewModel.comments[idx].date,
                                        isCommentUser: user!.email! == mainFirestoreViewModel.comments[idx].email,
                                        documentId: self.post.id)
                            .padding(.horizontal, 3)
                            .onAppear {
                                
                                print("user!.email! = \(user!.email!)")
                                print("currentComment[\(idx)].id = \(mainFirestoreViewModel.comments[idx].id)")
                                print(user!.email! == mainFirestoreViewModel.comments[idx].email)
                                userInfoManager.getUserNickName(email: user!.email!)
                            }
                        
                    }
                    Spacer()
                }
                .onAppear {
                    let storage = Storage.storage().reference()
                    storage.child("MainPostImage/\(post.id).jpg").downloadURL { url, err in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        self.url = "\(url!)"
                    }
                    self.hitValue = post.hit
                    if post.likeUsers.contains(user?.email ?? "") {
                        isLiked = true
                    } else {
                        isLiked = false
                    }
                    
                    self.formatter = DateFormatter()
                    self.formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
                    print("post.date = \(post.date)")
                    dateString = self.formatter.string(from: self.post.date)

                }
            }
            .onAppear {
                mainFirestoreViewModel.getComment(collectionName: "MainPost", documentId: self.post.id)
                print("model.comments: \(mainFirestoreViewModel.comments)")
                for comment in mainFirestoreViewModel.comments {
                    self.currentComments.append(comment)
                }
                if user!.email! == post.author {
                    self.showPostDeleteButton = true
                }
                
            }
            MainCommentAddView(currentPost: self.post, currentComments: self.$currentComments)
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
                Button {
                    // 삭제 @State값을 토글한다.
                    self.showDeleteAlert.toggle()
                    print("게시글 삭제 버튼 pressed")
                } label: {
                    Image(systemName: showPostDeleteButton ? "trash" : "")
                        .foregroundColor(.red)
                        
                }
                .alert(isPresented: self.$showDeleteAlert) {
                    Alert(title: Text("게시글을 삭제하시겠습니까?"),
                          message: Text("삭제한 게시글은 복구할 수 없습니다."),
                          primaryButton: .destructive(Text("삭제"), action: {
                        mainFirestoreViewModel.deletePost(postId: self.post.id)
                    }),
                          secondaryButton: .cancel(Text("취소")))
                }
                
            }
        }
        .background(Color(Constant.CustomColor.lightBrown))
    }
}

struct SelectedMainPost_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMainPost(post: MainPost())
    }
}
