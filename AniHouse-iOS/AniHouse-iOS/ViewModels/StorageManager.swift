//
//  StorageManager.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/06.
//

import Foundation
import FirebaseStorage
import SwiftUI
class StorageManager: ObservableObject {

    let storage = Storage.storage()
    var imageURL = URL(string: "")
    @Published var mainPostImages = [String: UIImage]()
    
    
    // 이미지를 업로드
    func uploadImage(image: UIImage, uploadPostId: String) {
        print("StorageManager - uploadImage")
        let storageRef = storage.reference().child("MainPostImage/\(uploadPostId).jpg")
        let data = image.jpegData(compressionQuality: 0.5)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                guard error == nil else { return }
                guard let metadata = metadata else { return }
                print("metadata: \(metadata)")
            }
        }
    }
}
