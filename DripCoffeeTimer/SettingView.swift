//
//  SecondView.swift
//  MyTimerTest1
//
//  Created by MsMacM on 2024/08/15.
//

import SwiftUI

struct SettingView: View {
//    @State var timerValue = 10
    @Binding var timerValue: Int
//      timerValueは@AppStorageで設定読み込み
//    @AppStorage("timer_value") var timerValue = 10
    
    var body: some View {
        ZStack{
            Color("backgroundSetting")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("\(timerValue)秒")
                    .font(.largeTitle)
                    
                    
                Picker(selection: $timerValue) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                    Text("30").tag(30)
                    Text("40").tag(40)
                    Text("50").tag(50)
                    Text("60").tag(60)
                } label: {
                    Text("選択")
                }
                .pickerStyle(.wheel)
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var timerValue: Int = 10
    SettingView(timerValue: $timerValue)
}
