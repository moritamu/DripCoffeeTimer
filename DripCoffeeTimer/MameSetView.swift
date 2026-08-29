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

        ZStack {
            Color("backgroundSetting")
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("豆の量")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                //                format: .numberで数値を入力できる
                HStack {
                    TextField("豆の重さ", value: $dripData.settings.mame, format: .number)
                        .frame(width: 40)
                        .multilineTextAlignment(TextAlignment.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("g")
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                Text("お湯の注ぎ時間")
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                HStack {
                    //                注ぎ時間の設定
                    Spacer()
                    ForEach(0..<dripData.settings.time.count,  id: \.self) { i in
                        Text("\(i + 1)回")
                        TextField("お湯の注ぎ時間", value: $dripData.settings.time[i], format: .number)
                            .frame(width: 35)
                            .multilineTextAlignment(TextAlignment.trailing)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if i == (dripData.settings.time.count - 1) {Text("秒")
                        } else {Text("秒,")}
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    Spacer()
                }
                Picker(selection: $dripData.settings.kosa, label: Text("濃さ")) {
                    Text("薄い").tag(5.0)
                    Text("普通").tag(6.0)
                    Text("やや濃い").tag(7.0)
                    Text("濃い").tag(8.0)
                    // kosaはDoubleなので、tagにIntを指定するとSwiftの型推論が働いてうまく選択できない
                }
                .pickerStyle(.segmented)
                //            .padding(0)
                //  コーヒーの濃さ（標準は１００ｍｌで６ｇ）
                Text("コーヒーの濃さ：" + String(dripData.settings.kosa) + " (g/100ml)")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                //            Text("豆の重さ: " + String(format: "%.1f", dripData.mame))
                Text("お湯の量")
                HStack {
                    ForEach(Array(dripData.ArrayHotW.enumerated()), id: \.offset) { idx, hotW in
                        if idx > 0 {Text(" , ")}
                        Text("\(idx+1)回目 \(String(format: "%3d", Int(hotW)))g")
                        //                                        .padding([.bottom, .trailing])
                    }
                }
                Spacer()
            }
        }//ここで.onDisappearで設定値を書き込めばいい
    }
}

#Preview {
    // プレビュー用のダミーデータを用意
    // DripData や Settings の実際の定義に合わせて初期値を調整してください
    let previewSettings = DripSettings(
        mame: 12.0,                 // 豆の量(g)
        kosa: 6.0, time: [30, 20, 15]                   // 濃さ(g/100ml)
    )
    let previewDripData = DripData()
    MameSetView(dripData: previewDripData)
}
