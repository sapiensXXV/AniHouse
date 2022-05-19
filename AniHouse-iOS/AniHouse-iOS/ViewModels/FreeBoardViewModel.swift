//
//  FreeBoardViewModel.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import Foundation
import Firebase
import FirebaseFirestore

class FreeBoardViewModel: ObservableObject {
    @Published var freeBoardContents: [FreeBoardContent] = [FreeBoardContent]()
    @Published var comments: [Comment] = []
    @Published var currentPostId: String = ""
    @Published var uploadPostId: String = ""

    //MARK: - 데이터 읽기
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("FreeBoard").order(by: "date", descending: true).getDocuments { snapshot, error in
            guard error == nil else { return }
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.freeBoardContents = snapshot.documents.map { data in
                        var freeBoardContent =  FreeBoardContent(id: data.documentID,
                                             title: data["title"] as? String ?? "",
                                             body: data["body"] as? String ?? "",
                                             author: data["author"] as? String ?? "",
                                             hit: data["hit"] as? Int ?? 0,
                                             likeUsers: data["likeUser"] as? [String] ?? [],
                                             date: data["date"] as? Date ?? Date())
                        self.currentPostId = data.documentID
                        let postTimeStamp = data["date"] as? Timestamp
                        freeBoardContent.date = postTimeStamp?.dateValue() ?? Date()
//                        print("posts: \(self.posts)")
                        return freeBoardContent
                    }
                }
            } else {
                // error
                // snapshot이 없음.
            }
        }
        
    }
    
    //MARK: - 데이터 쓰기
    func addData(title: String, body: String, author: String, hit: Int, date: Date) {
        print("FreeBoardViewModel - addData()")
        let db = Firestore.firestore()
        let ref = db.collection("FreeBoard").document()
        let id = ref.documentID
        
        ref.setData(["title": title,
                     "body": body,
                     "author": author,
                     "hit": hit,
                     "likeUser": [],
                     "date": date]) { error in
            guard error == nil else { return }
        }
        self.uploadPostId = id
        self.getData()
    }
    
    func deletePost(postId: String) {
        print("FreeBoardViewModel - deletePost(\(postId))")
        let db = Firestore.firestore()
        db.collection("FreeBoard").document(postId).delete()
        self.getData()
    }
    
    
    /// post: 현재 접근한 글
    /// currentUser: 글의 좋아요 유저 목록에서 추가할 유저의 이메일
    func addLike(post: FreeBoardContent, currentUser: String) {
        let db = Firestore.firestore()
        var currentLikeUsers = post.likeUsers
        /// 파이어베이스 딜레이를 방지하기위해서 혹시 이미 배열 내부에 유저가 있을 때만 추가.
        if(!currentLikeUsers.contains(currentUser)) {
            currentLikeUsers.append(currentUser)
        }
//        let currentHit = post.hit + 1
        db.collection("FreeBoard").document(post.id).setData(["likeUser": currentLikeUsers, "hit": currentLikeUsers.count], merge: true) { error in
            if let e = error { print(e.localizedDescription) }
        }
        self.getData()
    }
    
    /// post: 현재 접근한 글
    /// currentUser: 글의 좋아요 유저 목록에서 지울 유저의 이메일
    func deleteLike(post: FreeBoardContent, currentUser: String) {
        let db = Firestore.firestore()
        let currentLikeUsers = post.likeUsers.filter { $0 != currentUser }
        db.collection("FreeBoard").document(post.id).setData(["likeUser": currentLikeUsers, "hit": currentLikeUsers.count], merge: true) { error in
            if let e = error { print(e.localizedDescription) }
        }
        self.getData()
    }
    
    
    //MARK: - 코멘트
    func getComment(collectionName: String, documentId: String) {
        let db = Firestore.firestore()
        print("FreeBoardViewModel - getComment(\(collectionName), \(documentId))")
        db.collection(collectionName).document(documentId)
            .collection("comment").order(by: "date", descending: false).getDocuments { snapshot, error in
                guard error == nil else { return }
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.comments = snapshot.documents.map { data in
                            var comment =  Comment(id: data.documentID,
                                                   email: data["email"] as? String ?? "",
                                                   nickName: data["nickName"] as? String ?? "",
                                                   content: data["content"] as? String ?? "",
                                                   date: data["date"] as? Date ?? Date())
                            let commentTimeStamp = data["date"] as? Timestamp
                            comment.date = commentTimeStamp?.dateValue() ?? Date()
                            return comment
                        }
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        
    }
    
    func addComment(collectionName: String, documentId: String, newComment: Comment) {
        let db = Firestore.firestore()
        let ref = db.collection(collectionName).document(documentId)
            .collection("comment").document()
        ref.setData(["id": ref.documentID,
                     "email": newComment.email,
                     "nickName": newComment.nickName,
                     "content": newComment.content,
                     "date": newComment.date]) { error in
        }
        Task {
            try? await getComment(collectionName: collectionName, documentId: documentId)
        }
        
    }
    
    func deleteComment(collectionName: String, documentId: String, commentId: String) {
        let db = Firestore.firestore()
        print("deleteComment-commentId: \(commentId)")
        db.collection(collectionName).document(documentId)
            .collection("comment").document(commentId).delete { error in
        }
        Task {
            try? await getComment(collectionName: collectionName, documentId: documentId)
        }
    }

    
//    private var db = Firestore.firestore()
//
//    func fetchData() {
//        db.collection("FreeBoard").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//
//            self.freeBoardContents = documents.map { (QueryDocumentSnapshot) -> FreeBoardContent in
//                let data = QueryDocumentSnapshot.data()
//
//                let title = data["title"] as? String ?? ""
//                let body = data["body"] as? String ?? ""
//                let priority = data["priority"] as? String ?? ""
//                let author = data["author"] as? String ?? ""
//                let hit = data["hit"] as? Int ?? 0
//                let hitCheck = data["hitCheck"] as? Bool ?? false
//
//                let freeBoardContent = FreeBoardContent(title: title, body: body, priority: priority, author: author, hit: hit, hitCheck: hitCheck)
//                return freeBoardContent
//            }
//        }
//    }
}
