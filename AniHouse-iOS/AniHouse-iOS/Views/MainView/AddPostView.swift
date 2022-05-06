//
//  AddPostView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI
import Firebase

struct AddPostView: View {
    @ObservedObject var model = MainPostViewModel()
    @State private var isShowingPhotoPicker = false
    @State private var uploadImage: UIImage = UIImage(systemName: "photo.on.rectangle")!
    
    @State private var title = ""
    @State private var content = ""
    
    @State var categorieName: String = "카테고리"
    var categories: [String] = ["강아지", "고양이", "파충류", "조류", "어류", "기타"]
    
    var storageManager = StorageManager()
    
    
    @Environment(\.presentationMode) var presentationMode
    
    let user = Auth.auth().currentUser
    @State var postInfo: MainPost = MainPost() // 값들을 저장할 MainPost
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // 제목을 입력하는 부분
                TextField("제목을 입력하세요", text: $title)
                    .padding(5)
                    .cornerRadius(15)
                // 카테고리를 이 아래에 구현.
                
                Divider()
                ZStack(alignment: .topLeading) {
                    // 본문내용을 입력하는 부분
                    TextEditor(text: $content)
                        .frame(minWidth: nil, idealWidth: .infinity, maxWidth: nil, minHeight: 300, idealHeight: 400, maxHeight: 450)
                    
                    if content.isEmpty {
                        Text("내용을 입력하세요")
                            .foregroundColor(Color.secondary)
                            .padding(5)
                    }
                }
                Divider()
                HStack {
                    Text("사진을 선택해주세요 📷")
                        .fontWeight(.black)
                }
                
                Image(uiImage: uploadImage)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color("add-image-color"))
//                    .font(.system(size: 50))
                    .frame(width: 60, height: 60)
                    .padding(20)
                    .background(Color("Light Gray"))
                    .cornerRadius(15)
                    .onTapGesture {
                        // 이미지 추가작업 시작
                        isShowingPhotoPicker = true
                    }
                Spacer()
                
                Button {
                    // 올바른지 검사하기, 알림창 내보내기
                    postValidationCheck()
                    // 파이어스토어에 저장하기
                    model.addData(title: title,
                                  body: content,
                                  image: uploadImage,
                                  author: user?.email ?? "unknown",
                                  hit: 0,
                                  date: Date())
                    model.getData()
                    print("model.uploadPostID: \(model.uploadPostId)")
                    storageManager.uploadImage(image: uploadImage, uploadPostId: model.uploadPostId)
                    
                    presentationMode.wrappedValue.dismiss()
                    
                    
                    
                } label: {
                    Text("제출하기")
                        .foregroundColor(Color.white)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(13)
                        .padding(.top, 5)
                }

            } //VStack
            
        }
        .navigationTitle("🐱 글쓰기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 10)
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            //content
            PhotoPicker(bindedImage: $uploadImage)
            
        })
    }
    
    // 새로 생성할 MainPost 객체의 내용이 올바른지 검사한다.
    func postValidationCheck() {
        
    }
    
    // 포스팅할 데이터를 파이어스토어에 저장한다.
//    mutating func addPostFirestore() {
//        print("AddPostView - addPostFirestore")
//        postInfo.title = title
//        postInfo.body = content
//        postInfo.author = user?.email
//    }
    
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddPostView()
        }
    }
}


