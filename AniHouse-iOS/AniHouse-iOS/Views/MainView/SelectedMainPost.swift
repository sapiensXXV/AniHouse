//
//  SelectedMainPost.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/07.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct SelectedMainPost: View {
    var post: MainPost = MainPost()
    
    @State var url = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                Rectangle().frame(height: 0)
                if url != "" {
                    AnimatedImage(url: URL(string: url)!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                } else {
                    Loader()
                }
                
                Button {
                    //action
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        
                }
                Text("\(post.title)")
                    .font(Font.custom("KoreanSDNR-B", size: 22))
                    .fontWeight(.semibold)
                    .padding()
                Text("\(post.body)")
                    .font(Font.custom("KoreanSDNR-M", size: 18))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                Spacer()
            }
            .onAppear {
                let storage = Storage.storage().reference()
                storage.child("MainPostImage/\(post.id).jpg").downloadURL { url, err in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.url = "\(url!)"
                }
            }
        }
        
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
}

struct SelectedMainPost_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMainPost()
    }
}
