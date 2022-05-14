//
//  UserInfoViewModel.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase


class UserInfoViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    @Published var userNickName: String = ""
    @Published var userInfo: [UserInfo] = [UserInfo]()
    
    func addUser(name: String, nickName: String, email: String, birth: Date) {
        let db = Firestore.firestore()
        let ref = db.collection("userInfo").document(email)
        ref.setData(["name": name,
                     "nickName": nickName,
                     "email": email,
                     "birth": birth], merge: true) { error in
            guard error == nil else { return }
        }
    }
    
    func getUserNickName() {
        
        let db = Firestore.firestore()
        let email = user!.email! // 현재 유저의 이메일
        print("getUserInfo() - [\(email)]")
        
        db.collection("userInfo").document(email).getDocument(source: .cache) { document, error in
            if let document = document {
                print(email)
                self.userNickName = document.get("nickName") as! String
                print("getnickName: \(self.userNickName)")
            } else {
                print("닉네임을 가져오는데 실패했어요")
            }
        }
    }
    
}
