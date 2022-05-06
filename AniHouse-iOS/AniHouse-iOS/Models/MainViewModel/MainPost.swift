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
//    var image: UIImage? = UIImage(named: Constant.ImageName.defaultImage) 이미지는 파이어 스토어 말고 스토리지를 이용하자.
    var author: String = ""
    
    var hit: Int = 0
    var hitToggle: Bool = false
    
    var date: Date = Date()
    
//    var comments: [comment] = [MainPostComment]()
}
