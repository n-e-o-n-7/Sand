//
//  DictView.swift
//  Sand
//
//  Created by 许滨麟 on 2021/5/23.
//

import SwiftUI

struct DictView: View {
    @State private var username: String = ""
    @State private var isEditing = false
    @State private var res = ""
    @State private var match: [String] = []
    var body: some View {
        VStack {
            TextField(
                "User name (email address)",
                text: $username
            ) { isEditing in
                self.isEditing = isEditing
            } onCommit: {
                res = Stardict.query(word: username)?.translation ?? ""
            }
            .disableAutocorrection(true)
//        .border(Color(UIColor.separator))
            Text(res)
                .foregroundColor(isEditing ? .red : .blue)
                .onChange(of: username, perform: { s in
                    match = Stardict.match(word: s).map { $0.translation ?? "" }
                })
            ForEach(match, id: \.self) { e in
                Text(e)
            }
        }.frame(width: 400, height: 700)
    }
}

struct DictView_Previews: PreviewProvider {
    static var previews: some View {
        DictView()
    }
}
