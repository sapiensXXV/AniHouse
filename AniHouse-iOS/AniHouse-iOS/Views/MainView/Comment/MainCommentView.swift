//
//  MainCommentView.swift
//  AniHouse-iOS
//
//  Created by Jaehoon So on 2022/05/12.
//

import SwiftUI

struct MainCommentView: View {
    
    var nickName: String?
    var content: String?
    var date: Date?
    @State var dateString: String = ""
    @State var formatter = DateFormatter()
    
    init(nickName: String, content: String, date: Date) {
        self.nickName = nickName
        self.content = content
        self.date = date
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle().frame(height: 0)
            HStack{
                
                Image(systemName: "person")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(.orange)
                    )
                VStack(alignment: .leading) {
                    Text(nickName!)
                        .fontWeight(.semibold)
                    Text(dateString)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
            }
            Text(content!)
                .fontWeight(.light)
                .padding(.leading, 5)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background(Color(Constant.CustomColor.muchLightGray))
        .cornerRadius(5)
        .onAppear {
            self.formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
            self.dateString = formatter.string(from: self.date!)
        }
    }
}

struct MainCommentView_Previews: PreviewProvider {
    static var previews: some View {
        MainCommentView(nickName: "소재훈", content: "댓글입니다~~", date: Date())
    }
}
