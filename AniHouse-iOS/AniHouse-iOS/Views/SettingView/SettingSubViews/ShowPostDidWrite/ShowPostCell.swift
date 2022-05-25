//
//  ShowPostCell.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/25.
//

import SwiftUI

struct ShowPostCell: View {
    
    @EnvironmentObject var mainPostViewModel: MainPostViewModel
    
    var title: String = ""
    var content: String = ""
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider().opacity(0)
            HStack {
                VStack {
                    Text(self.title)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Text(self.content)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                
                Spacer()
                Image(systemName: "chevron.forward")
            }
            
        }
        .padding()
        .background(Color(Constant.CustomColor.lightBrown))
        .cornerRadius(5)
    }
}

struct ShowPostCell_Previews: PreviewProvider {
    static var previews: some View {
        ShowPostCell(title: "제목입니다~", content: "본문입니다~")
    }
}
