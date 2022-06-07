//
//  ReviseFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/08.
//

import SwiftUI
import FirebaseFirestore

struct ReviseFreeBoardView: View {
    @State private var showingAlert = false
    @State private var showingFailureAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    
    @State var post: FreeBoardContent = FreeBoardContent() // 게시글 객체를 넘겨받음.
    
    var body: some View {
        VStack(alignment: .leading) {
            // 제목을 입력하는 부분
            TextField("제목을 입력하세요", text: $post.title)
                .font(.system(size: 20, weight: .heavy, design: .default))
                .padding(5)
                .cornerRadius(15)
                .disableAutocorrection(true)
                .autocapitalization(.none)

            
            Divider()
            ZStack(alignment: .topLeading) {
                // 본문내용을 입력하는 부분
                TextEditor(text: $post.body)
                    .font(.system(size: 16))
                    .frame(minWidth: nil, idealWidth: .infinity, maxWidth: nil, minHeight: 300, idealHeight: 400, maxHeight: 450)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                //                        .background(Color(Constant.CustomColor.lightBrown))
                
                if post.body.isEmpty {
                    Text("내용을 입력하세요")
                        .font(.system(size: 16))
                        .foregroundColor(Color.secondary)
                        .padding(5)
                }
            }
            Spacer()
        }
        .background(Color(Constant.CustomColor.lightBrown).edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    if post.title == "" || post.body == "" {
                        showingFailureAlert = true
                    }
                    else {
                        showingFailureAlert = false
                        freeFirestoreViewModel.editPost(postId: post.id, title: post.title, body: post.body, date: Date())
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("저장")
                })
            }
        }
        .alert(isPresented: $showingFailureAlert) {
            Alert(title: Text("모든 항목을 작성해주세요"), message: nil, dismissButton: .default(Text("확인")))
        }
    }
}

struct ReviseFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ReviseFreeBoardView()
    }
}
