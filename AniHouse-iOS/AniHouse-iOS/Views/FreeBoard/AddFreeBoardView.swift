//
//  AddFreeBoardView.swift
//  AniHouse-iOS
//
//  Created by 최은성 on 2022/04/02.
//

import SwiftUI
import Firebase

struct AddFreeBoardView: View {
    @State private var boardTitle = ""
    @State private var boardBody = ""
    @State private var showingAlert = false
    @State private var showingFailureAlert = false

    @EnvironmentObject var freeFirestoreViewModel: FreeBoardViewModel
    @EnvironmentObject var storageManager: StorageManager

    @Environment(\.presentationMode) var presentationMode
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        Form {
            Section(header: Text("게시글 제목").fontWeight(.heavy)) {
                TextField("제목을 입력하세요", text: $boardTitle)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("게시글 내용")) {
                TextEditor(text: $boardBody)
                    .frame(height: 300)
                    .foregroundColor(Color.black)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            // alert을 같은 view에 넣으면 정상적으로 처리가 안되므로 여기에 alert을 추가함
            .alert(isPresented: $showingFailureAlert) {
                Alert(title: Text("모든 항목을 작성해주세요"), message: nil, dismissButton: .default(Text("확인")))
            }
            
            Button(action: {
                // 제목 혹은 내용을 작성하지 않았을 경우
                if boardTitle == "" || boardBody == "" {
                    showingFailureAlert = true
                    showingAlert = false
                }
                // 모두 작성한 경우
                else {
                    showingFailureAlert = false
                    showingAlert = true
                    
                    // 시간에 따라 작성된 게시글 우선순위를 둠
                    // 파이어스토어에 저장하기
                    freeFirestoreViewModel.addData(title: boardTitle,
                                  body: boardBody,
                                  author: user?.email ?? "unknown",
                                  hit: 0,
                                  date: Date())
                    freeFirestoreViewModel.getData()

                    boardTitle = ""
                    boardBody = ""
                                        
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("게시글 올리기")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct AddFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        AddFreeBoardView()
    }
}
