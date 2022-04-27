//
//  AddPostView.swift
//  AniHouse-iOS
//
//  Created by administrator on 2022/04/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Binding var selectedImageUrl: URL?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>){
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                parent.selectedImageUrl = imageUrl
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddPostView: View {
    @State private var postTitle = ""
    @State private var postContent = ""
    private var category = ["강아지", "고양이", "물고기", "새", "기타"]
    @State private var selectedCategory = 0
    private var buttonText = ["모든 항목을 작성해주세요", "자랑하기"]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var image = UIImage()
    @State private var imageUrl: URL?
    @State private var showImagePicker = false
    
    
    var body: some View {
        Form {
            Section(header: Text("게시글 제목")) {
                TextField("제목을 입력하세요", text: $postTitle)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("카테고리")) {
                Picker("카테고리", selection: $selectedCategory){
                    ForEach(0 ..< 5) {
                        Text(self.category[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("사진")){
                ZStack{
                    Text("사진 추가")
                    Image(uiImage: self.image)
                        .resizable()
                        .frame(width: 100, height: 100)
                    Button(action: {
                        showImagePicker = true
                    }){}
                        .frame(width: 100, height: 100)
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, selectedImageUrl: self.$imageUrl)
                        }
                }.frame(maxWidth: .infinity)
            }
            
            Section(header: Text("내용")) {
                TextEditor(text: $postContent)
                    .frame(height: 300)
                    .foregroundColor(Color.black)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            Section{
                Button(action: {
                    if let url = imageUrl {
                        let date = Timestamp.init()
                        let db = Firestore.firestore()
                        db.collection("Post")
                            .document(postTitle).setData(["title": postTitle, "category": selectedCategory, "content": postContent, "date": date, "url": url.path])
                        
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let imageRef = storageRef.child("images/image01.jpeg")
                        let data = image.jpegData(compressionQuality: 0.2)
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        if let data = data { imageRef.putData(data, metadata: metadata) { metadata, error in
                            guard let metadata = metadata else {
                                //error
                                return
                            }
                        }
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                }) {
                    Text(buttonText[imageUrl == nil || postTitle == "" || postContent == "" ? 0 : 1])
                }.disabled(imageUrl == nil || postTitle == "" || postContent == "")
            }
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
