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
    @State var selectedData: FreeBoardContent
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("게시글 제목").fontWeight(.heavy)) {
                TextField("제목을 입력하세요", text: $selectedData.title)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("게시글 내용")) {
                TextEditor(text: $selectedData.body)
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
                if selectedData.title == "" || selectedData.body == "" {
                    showingFailureAlert = true
                    showingAlert = false
                }
                // 모두 작성한 경우
                else {
                    showingFailureAlert = false
                    showingAlert = true

                    let db = Firestore.firestore()
                    db.collection("FreeBoard").document(String(selectedData.priority)).setData(["title":selectedData.title,"body":selectedData.body, "priority":selectedData.priority])

                    
                    // 작성하였으므로 내용 삭제
                    selectedData.title = ""
                    selectedData.body = ""
                    
                    presentationMode.wrappedValue.dismiss()
                    
                }
            }) {
                Text("게시글 수정하기")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text("수정 완료!"), message: nil, dismissButton: .default(Text("확인")))
//            }
        }
    }
}

struct ReviseFreeBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ReviseFreeBoardView(selectedData: .init(title: "", body: "", priority: 0))
    }
}
