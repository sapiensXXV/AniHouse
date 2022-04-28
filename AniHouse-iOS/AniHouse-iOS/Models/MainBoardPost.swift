//
//  MainBoardPost.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import Foundation
import SwiftUI

class MainBoardPost: Identifiable {
    let id = UUID()
    var title: String = "title"
    var content: String = "content"
    var postDate: Date = Date()
}

extension MainBoardPost {
    static var dummyPostArray: [MainBoardPost] {
        return [
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost(),
            MainBoardPost()
        ]
    }
}
