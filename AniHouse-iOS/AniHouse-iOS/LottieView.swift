//
//  LottieView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/03/26.
//

import Foundation
import SwiftUI
import UIKit
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String = "success"
    var loopMode: LottieLoopMode = .loop
    
    init(_ jsonName: String,
         _ loopMode: LottieLoopMode = .loop) {
        print("LottieView - init() called. jsonName: \(jsonName)")
        self.name = jsonName
        self.loopMode = loopMode
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        print("LottieView - makeUIView called")
        let view = UIView(frame: .zero) // 위치도 0, 크기도 0으로 준다.

        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.backgroundBehavior = .pauseAndRestore

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView("walking_dog", .loop)
    }
}

