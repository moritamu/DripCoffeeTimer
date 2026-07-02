//
//  MameSetView.swift
//  MyTimerTest1
//
//  Created by MsMacM on 2024/10/26.
//  お湯の注ぎ回数を変更できるようにしたい
//  たぶんdripData.time.countでdripData.time(kaisu)があるかないかで判断できる

import SwiftUI

struct MameSetView: View {
    @State var dripData: DripData
    
    var body: some View {
//        @Bindable var dripData = dripData
        
        VStack {
            Spacer()
            Text("豆の重さを入力")
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                format: .numberで数値を入力できる
            HStack {
                Spacer()
                TextField("豆の重さ", value: $dripData.mame, format: .number)
                    .frame(width: 100)
                    .multilineTextAlignment(TextAlignment.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("g")
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            Text("お湯の注ぎ時間")
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            HStack {
//                注ぎ時間の設定
                Spacer()
                ForEach(0..<dripData.time.count,  id: \.self) { i in
                    Text("\(i + 1)回")
                        TextField("お湯の注ぎ時間", value: $dripData.time[i], format: .number)
                            .frame(width: 40)
                            .multilineTextAlignment(TextAlignment.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("秒:")
                }

                Spacer()
            }

            //  コーヒーの濃さ（標準は１００ｍｌで６ｇ）
            Text("コーヒーの濃さ：" + String(dripData.kosa) + " (g/100ml)")
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

            Picker(selection: $dripData.kosa, label: Text("濃さ")) {
                Text("薄い").tag(5.0)
                Text("普通").tag(6.0)
                Text("やや濃い").tag(7.0)
                Text("濃い").tag(8.0)
// kosaはDoubleなので、tagにIntを指定するとSwiftの型推論が働いてうまく選択できない
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
//            Text("豆の重さ: " + String(format: "%.1f", dripData.mame))
            Text("はじめのお湯の量: " + String(format: "%.1f", dripData.hotWT * 0.2))
                .padding([.bottom, .trailing])
            Text("２回目のお湯の量: " + String(format: "%.1f", dripData.hotWT * 0.4))
                .padding([.bottom, .trailing])
            Text("３回目のお湯の量: " + String(format: "%.1f", dripData.hotWT))
                .padding([.bottom, .trailing])
            Spacer()
            

                 

        }
    }
}

#Preview {
    MameSetView(dripData: .init(mame: 12, kosa: 6, time: [10,20,30]))
}
