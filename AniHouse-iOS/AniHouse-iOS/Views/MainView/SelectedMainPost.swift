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
    
    @ObservedObject var model = MainPostViewModel()
    
    @State var post: MainPost = MainPost() // 게시글 객체를 넘겨받음.
    @State var hitValue: Int = 0 // 현재 좋아요 개수
    @State private var animate = false // 애니매이션 동작여부
    @State var isLiked: Bool = false // 현재 유저가 좋아요를 체크했는지 여부
    @State var dateString: String = ""
    @State var idGetComment: Bool = false
    @State var currentComments: [Comment] = [Comment]()
    
    @State var formatter: DateFormatter = DateFormatter()
    
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        self.isLiked ? 0.7 : 1.3
    }

    let user = Auth.auth().currentUser // 현재 유저객체
    @State var url = ""
    
    // 좋아요 애니메이션
//    init(post: MainPost) {
//        self.post = post
//        self.storeManager.getComment(collectionName: "MainPost", documentId: post.id)
//    }
    
    var body: some View {
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
                            DispatchQueue.main.async {
                                model.deleteLike(post: self.post, currentUser: self.user?.email ?? "")
                            }
                            self.isLiked.toggle()
                            hitValue -= 1
                        } else {
                            /// 좋아요를 누르지 않은 상태일 때
                            DispatchQueue.main.async {
                                model.addLike(post: self.post, currentUser: self.user?.email ?? "")
                                
                            }
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
                MainCommentAddView(currentPost: self.post)
                ForEach(self.currentComments) { comment in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(comment.nickName)
                                .fontWeight(.semibold)
                            Spacer()
                            Text(self.formatter.string(from: comment.date))
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            
                        }
                        Text(comment.content)
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
            model.getComment(collectionName: "MainPost", documentId: self.post.id)
            print("model.comments: \(model.comments)")
            for comment in model.comments {
                self.currentComments.append(comment)
            }
            if model.comments.isEmpty {
                self.currentComments.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    model.getComment(collectionName: "MainPost", documentId: self.post.id)
                    for comment in model.comments {
                        self.currentComments.append(comment)
                    }
                    print("비어있어서 다시 수행했어요^^")
                    print("self.currentComments: \(self.currentComments)")
                }
            }
            
        }
        
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
        
        
        
    }
    
}

struct SelectedMainPost_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMainPost(post: MainPost())
    }
}
