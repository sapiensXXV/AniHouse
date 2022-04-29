//
//  MainViewCell.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/04/28.
//

import SwiftUI

struct MainViewCell: View {
    
    var mainImage: Image = Image(Constant.ImageName.defaultImage)
    var title: String = "타이틀"
    var content: String = "본문 미리보기"
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(Constant.ImageName.defaultImage)
                .resizable()
                .frame(minWidth: 120, idealWidth: 140, maxWidth: 160,
                       minHeight: 120, idealHeight: 140, maxHeight: 160)
                .cornerRadius(10)
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
    }
}

struct MainViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MainViewCell()
    }
}
