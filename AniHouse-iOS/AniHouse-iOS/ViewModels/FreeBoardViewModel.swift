//
//  FreeBoardViewModel.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import Foundation
import FirebaseFirestore

class FreeBoardViewModel: ObservableObject {
    @Published var freeBoardContents = [FreeBoardContent]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("FreeBoard").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.freeBoardContents = documents.map { (QueryDocumentSnapshot) -> FreeBoardContent in
                let data = QueryDocumentSnapshot.data()
                
                let title = data["title"] as? String ?? ""
                let body = data["body"] as? String ?? ""
                let priority = data["priority"] as? String ?? ""
                let author = data["author"] as? String ?? ""
                let hit = data["hit"] as? Int ?? 0
                let comment = data["comment"] as? [String] ?? [""]
                let hitCheck = data["hitCheck"] as? Bool ?? false
                
                let freeBoardContent = FreeBoardContent(title: title, body: body, priority: priority, author: author, hit: hit, comment: comment,hitCheck: hitCheck)
                return freeBoardContent
            }
        }
    }
}
