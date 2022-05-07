//
//  MainViewCell.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI
import Firebase

struct MainViewCell: View {
    
    @ObservedObject var model = MainPostViewModel()
    
    @State var image: UIImage? = UIImage(named: Constant.ImageName.defaultImage)
    @State var url = ""
    var imageName: String = ""
    var title: String = "타이틀"
    var content: String = "본문 미리보기"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common, options: .none).autoconnect()
    
    @StateObject var storageManager = StorageManager()
    
    init(imageName: String, title: String, content: String) {
        self.imageName = imageName
        self.title = title
        self.content = content
        model.getData()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle().frame(height: 0)
            if url != "" {
                AnimatedImage(url: URL(string: url)!)
                    .frame(width: 145, height: 145)
                    .cornerRadius(10)
                    .scaledToFill()
            }
            else {
                Loader()
            }
            
//            Image(uiImage: self.image!)
//                .resizable()
//                .frame(minWidth: 120, idealWidth: 140, maxWidth: 160,
//                       minHeight: 120, idealHeight: 140, maxHeight: 160)
//                .cornerRadius(10)
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.black)
                .lineLimit(1) // 한줄로 제한
            Spacer().frame(height:3)
            Text(content)
                .font(.system(size: 13))
                .foregroundColor(Color.secondary)
                .lineLimit(3) // 세줄로 제한
            
        }
        .padding(7)
        .background(Color("MainViewCellColor"))
        .cornerRadius(15)
        .shadow(color: .gray, radius: 2, x: 0, y: 0)
        .onAppear {
            
             
        }
        .onAppear {
            let storage = Storage.storage().reference()
            storage.child("MainPostImage/\(imageName).jpg").downloadURL { url, err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.url = "\(url!)"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                storage.child("MainPostImage/\(imageName).jpg").downloadURL { url, err in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.url = "\(url!)"
                }
            }
        }
    }
    
}

struct Loader: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {
        
    }
}

struct MainViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MainViewCell(imageName: "uMjkVL3MxsDJ6y5zlYEV",
                     title: "기본 타이틀",
                     content: "기본 본문")
    }
}
