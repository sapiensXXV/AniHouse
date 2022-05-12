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
//    func loadImage(imageName: String) {
//        let ref = Storage.storage().reference(forURL: "gs://anihouse-2b265.appspot.com/MainPostImage/\(imageName).jpg")
//        var image: UIImage?
////        var img: UIImage?
//
//        ref.downloadURL { url, error in
//            guard url != nil, error == nil else { return }
//
//            print("url: \(url!)")
//            let data = NSData(contentsOf: url!)
//            image = UIImage(data: data! as Data)!
//            self.mainPostImages[imageName] = image
//            print("mainPostImages[\(imageName)] = \(image!)")
//        }
//
//    }
    

}
