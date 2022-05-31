//
//  MainViewCell.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI
import UIKit
import Firebase

struct MainViewCell: View {
    
    @EnvironmentObject var mainFirestoreViewModel: MainPostViewModel
    @EnvironmentObject var userInfoModel: UserInfoViewModel
    @EnvironmentObject var storageManager: StorageManager
    
    
    @State var image: UIImage? = nil
    @State var url = ""
    var imageName: String = ""
    var title: String = "타이틀"
    var content: String = "본문 미리보기"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common, options: .none).autoconnect()
    
    var post: MainPost
    init(post: MainPost) {
        self.post = post
//        mainFirestoreViewModel.getData()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
//            Divider().frame(height: 0)


            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(minWidth: 165, idealWidth: 170, maxWidth: 175,
                           minHeight: 165, idealHeight: 170, maxHeight: 175)
                    .cornerRadius(0)
                    .scaledToFill()
                    .padding(0)
            } else {
                Image(Constant.ImageName.defaultImage)
                    .resizable()
                    .frame(minWidth: 165, idealWidth: 170, maxWidth: 175,
                           minHeight: 165, idealHeight: 170, maxHeight: 175)
                    .cornerRadius(0)
                    .scaledToFill()
                    .padding(0)
            }
            VStack(alignment: .leading)
            {
                HStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 11, height: 11)
                        .foregroundColor(.red)
                    Text("\(post.hit)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Spacer()
                }
                
                Text(post.title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .fontWeight(.black)
                    .lineLimit(1) // 한줄로 제한
                    
                Spacer().frame(height:1)
                Text(post.body)
                    .font(.system(size: 13))
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2) // 두 줄로 제한
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
                
            
        }
        .padding(0)
        .background(Color(Constant.CustomColor.muchLightBrown))
        .cornerRadius(10)
//        .shadow(color: .gray, radius: 2, x: 0, y: 0)
        .onAppear {
            loadMainImage(imageName: post.id)
            if self.url == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    loadMainImage(imageName: post.id)
                }
            }
            
        }
        
    }
    func loadMainImage(imageName: String) {
        let storage = Storage.storage()
        let mainImageRef = storage.reference().child("MainPostImage/\(imageName).jpg")
        mainImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("메인 사진을 찾았습니다.")
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
    
}


struct MainViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MainViewCell(post: MainPost())
    }
}
