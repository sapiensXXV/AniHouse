//
//  MainPostViewModel.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/05.
//

import Foundation
import Firebase

class MainPostViewModel: ObservableObject {
    @Published var posts: [MainPost] = [MainPost]()
    @Published var comments: [Comment] = [Comment]()
    @Published var currentPostId: String = ""
    @Published var uploadPostId: String = ""
    
    private var dummyComment = Comment(id: "comment id", author: "author", content: "body", date: Date())
    
    //MARK: - 데이터 읽기
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("MainPost").order(by: "date", descending: true).getDocuments { snapshot, error in
            guard error == nil else { return }
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.posts = snapshot.documents.map { data in
                        let post =  MainPost(id: data.documentID,
                                             title: data["title"] as? String ?? "",
                                             body: data["body"] as? String ?? "",
//                                             image: UIImage(named: Constant.ImageName.defaultImage), // 나중에 수정
                                             author: data["author"] as? String ?? "",
                                             hit: data["hit"] as? Int ?? 0,
                                             date: data["date"] as? Date ?? Date())
                        self.currentPostId = data.documentID
//                        print(post)
                        return post
                    }
                }
            } else {
                // error
                // snapshot이 없음.
            }
        }
        
    }
    
    func getComment() {
        let db = Firestore.firestore()
        
        db.collection("MainPost").document(currentPostId)
            .collection("comment").getDocuments { snapshot, error in
                guard error == nil else { return }
                if let snapshot = snapshot {
                    self.comments = snapshot.documents.map { data in
                        return Comment(id: data.documentID,
                                       author: data["author"] as? String ?? "",
                                       content: data["content"] as? String ?? "",
                                       date: data["date"] as? Date ?? Date())
                    }
                }
            }
    }
    
    func getPostId() {
        
    }
    
    //MARK: - 데이터 쓰기
    func addData(title: String, body: String, image: UIImage, author: String, hit: Int, date: Date) {
        print("MainPostViewModel - addData()")
        let db = Firestore.firestore()
        let ref = db.collection("MainPost").document()
        let id = ref.documentID
        
        ref.setData(["title": title,
                     "body": body,
                     "author": author,
                     "hit": hit,
                     "date": date]) { error in
            guard error == nil else { return }
//            print("uploadPostId = \(id)")
//            self.uploadPostId = id
//            self.getData()
            
        }
        self.uploadPostId = id
        self.getData()
//        db.collection("MainPost").addDocument(data: ["title": title,
//                                                     "body": body,
////                                                     "image": image,
//                                                     "author": author,
//                                                     "hit": hit,
//                                                     "date": date]) { error in
//            guard error == nil else { return }
//            self.getData()
//        }
        
    }
    
    func addComment(author: String, date: Date, content: String) {
        let db = Firestore.firestore()
        db.collection("MainPost").document(currentPostId)
            .collection("comment").addDocument(data: ["author": author,
                                                      "date": date,
                                                      "content": content]) { error in
                guard error == nil else { return }
                self.getData()
            }
    }
    
    func printMainPostLog(data: MainPost) {
        print(data)
    }
    
}
