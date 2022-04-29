//
//  AddPostView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI

struct AddPostView: View {
    
    @State private var isShowingPhotoPicker = false
    @State private var defaultImage: UIImage = UIImage(systemName: "photo.on.rectangle")!
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("제목을 입력하세요", text: $title)
                    .padding(5)
                    .cornerRadius(15)
                Divider()
                ZStack(alignment: .topLeading) {
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
                
                Image(uiImage: defaultImage)
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
                
            }
        }
        .navigationTitle("🐱 글쓰기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 10)
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            //content
            PhotoPicker(bindedImage: $defaultImage)
            
        })
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddPostView()
            AddPostView()
        }
    }
}
