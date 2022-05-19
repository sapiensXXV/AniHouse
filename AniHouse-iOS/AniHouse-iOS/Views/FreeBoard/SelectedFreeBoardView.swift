//
//  SelectedFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/05.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SelectedFreeBoardView: View {
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var userInfoManager: UserInfoViewModel

    @State var post: FreeBoardContent = FreeBoardContent() // 게시글 객체를 넘겨받음.

    @State var showingAlert = false
    @State var showModal = false
    @Environment(\.presentationMode) var presentationMode
    
    let user = Auth.auth().currentUser
    
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

    @State private var isPresented: Bool = false
    @State private var commentField: String = ""

    @Binding var showingOverlay: Bool
    
    var body: some View {
            VStack(alignment: .leading) {
                // 게시글 제목
                HStack {
                    Text(post.title)
                        .font(.system(size: 20))
                        .fontWeight(.bold)

                    Spacer()
                    
                    // 게시글 좋아요 버튼
                    Button(action: {
                        //action
                        if isLiked {
                            /// 게시글의 좋아요를 누른 상태일 때 Like를 지운다.
//                                DispatchQueue.main.async {
                            freeFirestoreViewModel.deleteLike(post: self.post, currentUser: self.user?.email ?? "")
//                                }
                            self.isLiked.toggle()
                            hitValue -= 1
                        } else {
                            /// 좋아요를 누르지 않은 상태일 때
//                                DispatchQueue.main.async {
                            freeFirestoreViewModel.addLike(post: self.post, currentUser: self.user?.email ?? "")
                                
//                                }
                            self.isLiked.toggle()
                            hitValue += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                            self.animate = false
                        })
                    }, label: {
                        Image(systemName: self.isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(self.isLiked ? .red : .gray)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 3)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading)
                    .scaleEffect(animate ? animationScale : 1)
                    .animation(Animation.easeIn(duration: animationDuration), value: animationScale)
                    
                    Text("\(self.hitValue)")
                        .font(.system(size: 16))

                }
                .padding()
                .onAppear {
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
                
                // 게시글 작성자
                VStack(alignment: .leading) {
                    Text(post.author)
                        .font(.system(size: 11))
                }
                .padding([.leading, .trailing])
                
                // 구분선
                Divider()
                
                // 게시글 내용
                VStack(alignment: .leading) {
                    Text(post.body)
                        .font(.system(size: 16))
                }
                .padding()
                
                // 구분선
                Divider()
                
                ScrollView {
                    ForEach(self.freeFirestoreViewModel.comments.indices, id: \.self.hashValue) { idx in
                        FreeCommentView(currentCommentId: freeFirestoreViewModel.comments[idx].id,
                                        nickName: freeFirestoreViewModel.comments[idx].nickName,
                                        content: freeFirestoreViewModel.comments[idx].content,
                                        date: freeFirestoreViewModel.comments[idx].date,
                                        isCommentUser: user!.email! == freeFirestoreViewModel.comments[idx].email,
                                        documentId: self.post.id)
                    
                    
                }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            // dots 클릭 시, 게시글 삭제 버튼과 수정 버튼 표시
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 삭제 @State값을 토글한다.
                        self.showDeleteAlert.toggle()
                        print("게시글 삭제 버튼 pressed")
                    }, label: {
                        Image(systemName: showPostDeleteButton ? "trash" : "")
                            .foregroundColor(.red)
                    })
                    .alert(isPresented: self.$showDeleteAlert) {
                        Alert(title: Text("게시글을 삭제하시겠습니까?"),
                              message: Text("삭제한 게시글은 복구할 수 없습니다."),
                              primaryButton: .destructive(Text("삭제"), action: {
                            freeFirestoreViewModel.deletePost(postId: self.post.id)
                        }),
                              secondaryButton: .cancel(Text("취소")))
                    }

                }
            }
//            .overlay (
//                editView
//                ,alignment: .topTrailing
//            )
                Divider()
                Spacer()
                FreeAddCommentView(currentPost: self.post, currentComments: self.$currentComments)
        }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .onAppear {
                freeFirestoreViewModel.getComment(collectionName: "FreeBoard", documentId: self.post.id)
                print("model.comments: \(freeFirestoreViewModel.comments)")
                for comment in freeFirestoreViewModel.comments {
                    self.currentComments.append(comment)
                }
                if user!.email! == post.author {
                    self.showPostDeleteButton = true
                }
                

            }
            .onAppear {
                showingOverlay = false
            }

        //        .padding(.leading, 10)
        //        .padding(.trailing, 10)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        //        .frame(maxWidth: .infinity)
        //        .padding(.bottom, 10)
    
    }

//    @ViewBuilder
//    private var editView: some View {
//        if isPresented {
//            VStack {
//                Button(action: {
//                    showingAlert = true
//                }, label: {
//                    Text("게시글 삭제")
//                        .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
//                            Button("삭제", role: .destructive) {
//                                freeFirestoreViewModel.deletePost(postId: self.post.id)
//                            }
//                            Button("취소", role: .cancel) {
//
//                            }
//                        }
//                })
//                .buttonStyle(BorderlessButtonStyle())
//                .padding(.bottom, 3)
//                .foregroundColor(.black)
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                    showModal = true
//                }, label: {
//                    Text("게시글 수정")
//                })
//                .buttonStyle(BorderlessButtonStyle())
//                .foregroundColor(.black)
//                .sheet(isPresented: self.$showModal) {
//                    ReviseFreeBoardView(selectedData: selectedData)
//                }
//            }
//            .padding(.trailing)
//            .background(Color.white)
//            .border(.black)
//        }
//    }
    
}
//struct SelectedFreeBoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedFreeBoardView(post: FreeBoardContent())
//    }
//}
//
