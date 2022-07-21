//
//  ContentView.swift
//  WidgetKit_Barebones
//
//  Created by 이로운 on 2022/07/21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var text: String = "I'm your widget!"
    @State var textColor: Color = Color.black
    @State var backgroundColor: Color = Color.white
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(backgroundColor)
                    .frame(width: 200, height: 200)
                    .cornerRadius(15)
                    .shadow(radius: 1)
                Text(text)
                    .foregroundColor(textColor)
                    .font(Font.system(size: 24, weight: .semibold, design: .default))
                    .frame(width: 200, height: 200, alignment: .center)
            }
            
            VStack {
                TextField("위젯에 어떤 텍스트를 띄워볼까요?", text: $text)
                    .textFieldStyle(.roundedBorder)
                ColorPicker("텍스트 색상", selection: $textColor)
                ColorPicker("배경 색상", selection: $backgroundColor)
                    .padding(.bottom, 20)
            }
            .frame(width: 300, height: 200)
            
            Button("적용") {
                let userDefaults = UserDefaults(suiteName: "group.WidgetKit_Barebones")
                userDefaults?.setValue(text, forKey: "text")
                userDefaults?.set(textColor.cgColor?.components, forKey: "textColor")
                userDefaults?.set(backgroundColor.cgColor?.components, forKey: "backgroundColor")
                
                WidgetCenter.shared.reloadAllTimelines()
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}
