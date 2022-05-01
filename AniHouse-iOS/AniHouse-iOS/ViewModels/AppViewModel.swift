//
//  AppViewModel.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/27.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
//    @Published var now = DispatchTime.now()
    
    var isSignedIn: Bool {
        return auth.currentUser != nil // true라면 가입되어 있는 유저
    }
    
    //로그인
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                print("로그인 실패")
                print(error!)
                
                return
            }
            
            // 성공
            DispatchQueue.main.async {
                self?.signedIn = true
//                self?.now = DispatchTime.now()
            }
        }
    }
    
    //회원가입
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // 성공
            DispatchQueue.main.async {
                self?.signedIn = true

            }
        }
    }
    
    //로그아웃
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}
