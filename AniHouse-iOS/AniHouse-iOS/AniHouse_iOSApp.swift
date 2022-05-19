//
//  AniHouse_iOSApp.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/16.
//

import SwiftUI
import Firebase

@main
struct AniHouse_iOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var mainFirestoreViewModel = MainPostViewModel()
    @StateObject var storageViewModel = StorageManager()
    @StateObject var userInfoViewModel = UserInfoViewModel()
    @StateObject var freeFirestoreViewModel = FreeBoardViewModel()
    
    var body: some Scene {
        WindowGroup {
            //뷰 모델 생성
            let viewModel = AppViewModel()
            LoginView()
                .environmentObject(viewModel)
                .environmentObject(mainFirestoreViewModel)
                .environmentObject(storageViewModel)
                .environmentObject(userInfoViewModel)
                .environmentObject(freeFirestoreViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
