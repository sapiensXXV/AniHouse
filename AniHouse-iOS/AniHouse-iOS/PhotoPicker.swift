//
//  PhotoPicker.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/29.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var bindedImage: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                //이미지 용량을 절반으로 압축 1로 바꾸면 100%
                guard let data = image.jpegData(compressionQuality: 0.5), let compressedImage = UIImage(data: data) else {
                    // 에러 출력
                    return
                }
                photoPicker.bindedImage = compressedImage
            } else {
                // 에러 반환
                
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    typealias UIViewControllerType = UIImagePickerController
}


