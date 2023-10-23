//
//  InitialView.swift
//  KeyHopper
//
//  Created by admin on 20.10.2023.
//

import SwiftUI

struct InitialView: View {
    @State private var name = "HELLO"
    @State private var count = 0
    
    var body: some View {
        ZStack {
            Color
                .white
                .ignoresSafeArea()
            VStack {
                Text("СЧЁТЧИК НАЖАТИЙ " + "\($count.wrappedValue)")
                Text("Hello, user, please enter your name!")
                TextField("Placeholder", text: $name)
                Button {
                    print("Button tapped!")
                    print("\($count.wrappedValue)")
                    count += 1
                } label: {
                    Text("TAP")
                }
                Button (action: {
                    print("Send")
                }, label: {
                    Text("SEND NAME AND GO NEXT")
                })
            }
        }
    }
}

#Preview {
    InitialView()
}
