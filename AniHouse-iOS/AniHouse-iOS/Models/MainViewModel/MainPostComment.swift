//
//  MainPostComment.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/05.
//

import Foundation

struct Comment: Identifiable {
    var id: String
    var author: String
    var content: String
    var date: Date
}
