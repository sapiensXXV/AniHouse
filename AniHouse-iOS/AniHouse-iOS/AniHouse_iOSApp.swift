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
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
//            LoginView()
            FreeBoardView(selectedData: .constant(.init(title: "", body: "", priority: 0)))
                .environmentObject(viewModel)
//            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
