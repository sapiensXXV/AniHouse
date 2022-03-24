//
//  SplashScreenView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State var isContentReady: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Text("Hello world!")
                .padding()
            if !isContentReady {
                mySplashScreenView.transition(.opacity)
            }
        }
        .onAppear {
            print("ContentView - onAppear() called")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                print("ContentView - 1.25s After")
                withAnimation{ isContentReady.toggle() }
            }
        }
    }
}

//MARK: - 스플래시 스크린
extension SplashScreenView {
    var mySplashScreenView: some View {
        Color.yellow.edgesIgnoringSafeArea(.all)
            .overlay(alignment: .center) {
                Text("스플래시 화면 입니다.")
                    .font(.largeTitle)
            }
    }
}


struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

