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
    var commentImage: UIImage = UIImage(systemName: "person")!
    @Published var mainPostImages = [String: UIImage]()
    @Published var profileImage: UIImage = UIImage(named: Constant.ImageName.defaultUserImage)!
    @Published var introduce: String = "자기소개 입니다."
    
    
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
    
    func getUserProfileImage(email: String) {
        print("StorageManager - getUserProfileImage")
        let storage = Storage.storage().reference()
        storage.child("user/profileImage/\(email)").downloadURL{ url, err in
//            print("url: \(url!)")
            guard err == nil else { return }
            self.downloadImage(url: url!)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.profileImage = UIImage(data: data)!
            }
        }
    }
    

    func uploadUserProfileImage(email: String) {
        print("StorageManager - uploadUserProfileImage()")
        let storageRef = storage.reference().child("user/profileImage/\(email)")
        let data = self.profileImage.jpegData(compressionQuality: 0.5)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                guard error == nil else { return }
                guard let metadata = metadata else { return }
//                print("metadata: \(metadata)")
            }
        }
    }
    
    
}
