//
//  CommentViewModel.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/28.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class CommentViewModel: ObservableObject {
    @Published var profileImage: UIImage = UIImage(systemName: "person")!
    
    func getUserProfileImage(email: String) {
        print("CommentViewModel - getUserProfileImage")
        let storage = Storage.storage().reference()
        storage.child("user/profileImage/\(email)").downloadURL{ url, err in
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
}
