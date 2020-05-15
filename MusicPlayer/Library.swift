//
//  Library.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 15.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("123")
                        }) {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(hex: "FD2D55"))
                                .background(Color(hex: "F3F2F4")).cornerRadius(10)
                        }
                        Button(action: {
                            print("321")
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(hex: "FD2D55"))
                                .background(Color(hex: "F3F2F4")).cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List {
                    LibraryCell()
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Library").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack {
                Text("Track Name")
                Text("Artist Name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
