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
    @State private var showDeniedAlert: Bool = false
    @State private var showForbidAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    let user = Auth.auth().currentUser
    @State var postInfo: MainPost = MainPost() // 값들을 저장할 MainPost
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
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
//                        .background(Color(Constant.CustomColor.lightBrown))
                    
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
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 10)
        .background(Color(Constant.CustomColor.lightBrown).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            //content
            PhotoPicker(bindedImage: $uploadImage)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }

            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    hideKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                
                Button {
                    // 올바른지 검사하기, 알림창 내보내기
                    
                    if !postValidationCheck() { self.showDeniedAlert.toggle() }
                    else if postContainForbidWord() {
                        self.showDeniedAlert.toggle()
                        self.showForbidAlert.toggle()
                    }
                    else {
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
                    }
                } label: {
                    Text("저장")
                }
                .alert(isPresented: self.$showDeniedAlert) {
                    var alertTitle: String = ""
                    var alertMessage: Text? = nil
                    if self.title == "" {
                        alertTitle = "제목을 입력해주세요"
                    } else if self.content.count < 5 {
                        alertTitle = "본문은 5글자 이상 입력해주세요"
                        alertMessage = Text("현재 \(self.content.count)글자")
                    } else if isEqualImage(img1: UIImage(systemName: "photo.on.rectangle")!, img2: self.uploadImage) {
                        alertTitle = "이미지를 업로드 해주세요"
                    } else if showForbidAlert {
                        return Alert(title: Text("상처주는 표현이 포함되어 있지 않나요?"), message: Text("부적절한 표현이 감지됩니다. 반복 등록시 이용이 제한될 수 있습니다."), dismissButton: .destructive(Text("알겠습니다")))
                    }
                    return Alert(title: Text(alertTitle), message: alertMessage, dismissButton: .default(Text("알겠습니다")))
                }

            }
        }
    }
    
    // 새로 생성할 MainPost 객체의 내용이 올바른지 검사한다.
    func postValidationCheck() -> Bool {
        if self.title == "" || self.content == "" || isEqualImage(img1: UIImage(systemName: "photo.on.rectangle")!, img2: self.uploadImage) {
            return false
        }
        return true
    }
    
    func postContainForbidWord() -> Bool {
        for forbidWord in Constant.forbidWord {
            if self.title.contains(forbidWord) || self.content.contains(forbidWord) {
                print("잡았다 요놈~~")
                return true
            }
        }
        return false
    }
    
    func isEqualImage(img1: UIImage, img2: UIImage) -> Bool {
        img1 === img2 || img1.pngData() == img2.pngData()
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddPostView()
        }
    }
}


