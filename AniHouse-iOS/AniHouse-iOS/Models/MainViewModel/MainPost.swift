//
//  MainPost.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/05.
//

import Foundation
import UIKit

struct MainPost: Identifiable {
    var id: String = ""
    var title: String = ""
    var body: String = ""
    var author: String = ""
    var hit: Int = 0
    var hitToggle: Bool = false
    var likeUsers: [String] = []
    var date: Date = Date()
}
