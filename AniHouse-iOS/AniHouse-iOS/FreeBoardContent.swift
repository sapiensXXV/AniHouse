//
//  FreeBoardContent.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import Foundation
import UIKit

struct FreeBoardContent: Identifiable {
    var id: String = ""
    var title: String = ""
    var body: String = ""
    var author: String = ""
    var hit: Int = 0
    var hitCheck: Bool = false
    var likeUsers: [String] = []
    var date: Date = Date()
}
