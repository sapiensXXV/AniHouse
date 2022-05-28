//
//  MainPostComment.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/05.
//

import Foundation
import UIKit

struct Comment: Identifiable {
    var id: String = ""
    var email: String
    var nickName: String
    var content: String
    var date: Date
}
