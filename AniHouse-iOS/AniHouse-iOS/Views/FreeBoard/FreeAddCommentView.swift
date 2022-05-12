//
//  FreeAddCommentView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/05/12.
//

import SwiftUI
import Firebase

struct FreeAddCommentView: View {
    @ObservedObject var storeManager = MainPostViewModel()
    @State var selectedData: FreeBoardContent
    var body: some View {
        VStack {
//            ForEach(0..<5) { _ in
//                HStack {
//                    Text("Hi")
//                    Text("Hello")
//                }
//            }
            List(storeManager.comments, id: \.email) {comment in
                HStack {
                    Text(comment.email)
                    Text(comment.content)
                    Text("Hi")
                }
            }
            .task {
                storeManager.getComment(collectionName: "FreeBoard", documentId: selectedData.priority)
            }
        }
//        .onAppear {
//            Task {
//
//            }
//        }
    }
}

//struct FreeAddCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FreeAddCommentView()
//    }
//}
