//
//  AddPostView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI
import Firebase

struct AddPostView: View {
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var storageManager: StorageManager
    
    @State private var isShowingPhotoPicker = false
    @State private var uploadImage: UIImage = UIImage(systemName: "photo.on.rectangle")!
    
    @State private var title = ""
    @State private var content = ""
    
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
                    .scaledToFit()
                    .foregroundColor(Color("add-image-color"))
//                    .font(.system(size: 50))
                    .frame(width: 80, height: 80)
                    .padding(0)
                    .background(Color("Light Gray"))
                    .cornerRadius(15)
                    .onTapGesture {
                        // 이미지 추가작업 시작
                        isShowingPhotoPicker = true
                    }
                Spacer()
            } //VStack
            
        }
        .navigationTitle("🐱 글쓰기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 10)
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            //content
            PhotoPicker(bindedImage: $uploadImage)
        })
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    hideKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                
                Button {
                    // 올바른지 검사하기, 알림창 내보내기
                    postValidationCheck()
                    // 파이어스토어에 저장하기
                    mainFirestoreViewModel.addData(title: title,
                                  body: content,
                                  image: uploadImage,
                                  author: user?.email ?? "unknown",
                                  hit: 0,
                                  date: Date())
                    storageManager.uploadImage(image: uploadImage, uploadPostId: mainFirestoreViewModel.uploadPostId)
                    mainFirestoreViewModel.getData()
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("저장")
                }
            }
        }
    }
    
    // 새로 생성할 MainPost 객체의 내용이 올바른지 검사한다.
    func postValidationCheck() {
        
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddPostView()
        }
    }
}


