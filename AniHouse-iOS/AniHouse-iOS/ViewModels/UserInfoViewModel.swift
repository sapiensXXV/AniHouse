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
    
    @Published var user = Auth.auth().currentUser
    @Published var userNickName: String = "userNickname"
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
    
    func getUserNickName(email: String) {
        if user == nil {
            print("유저가 없어요")
        }
        print("getUserNickName 닉네임 찾기: [\(email)]")
//        print("getUserInfo() - \(user?.email!)")
        let db = Firestore.firestore()
        
        db.collection("userInfo").document(email).getDocument { document, error in
            if let document = document {
                self.userNickName = document.get("nickName") as! String
                print("getnickName: \(self.userNickName)")
                print("닉네임을 찾았어요!")
            } else {
                print("닉네임을 가져오는데 실패했어요")
            }
        }
    }
    
}
