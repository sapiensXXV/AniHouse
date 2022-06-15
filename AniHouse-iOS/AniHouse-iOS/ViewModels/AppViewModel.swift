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

    @Published var signedIn = UserDefaults.standard.bool(forKey: "loginCheck")
    
//    @Published var now = DispatchTime.now()
    let auth = Auth.auth()
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
                self?.signedIn = false
                UserDefaults.standard.set(false, forKey: "loginCheck")
                return
            }
            
            // 성공
            DispatchQueue.main.async {
//                self?.signedIn = true
                print("로그인에 성공했습니다!")
                self?.signedIn = true
                UserDefaults.standard.set(true, forKey: "loginCheck")
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
        UserDefaults.standard.set(false, forKey: "loginCheck")
    }
    
}
