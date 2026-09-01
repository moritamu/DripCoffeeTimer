//
//  ContentView.swift
//  MyTimerTest1ー＞MyDripTimer 25/9/10
//
//  Created by MsMacM on 2024/08/15.
//  24/10/30 時間の設定ができるようにすること　完成11/1
//  音を鳴らす。ブルブルも　241117音はできた。
//  これをWatchOSに変更したい。
//  MyDripTimerをDripCoffeeTimerに変更する26/07/03 Gitを新しくする
//  Git関連メニューは、Integrate（統合）にある。
// 時間や湯量は配列を使うように変更した26/07/13
// UserDfaultを使って、入れ方の初期値を保存できるようにした。26/08/29

import SwiftUI

struct ContentView: View {
    @State var timerHandler: Timer?
    @State var count = 0

    @State var timervalue: Int = 10
    @State var showAlert = false
    @State var kaisu = 0
    @State var dripData: DripData
    //お湯を入れるのが何回めかのカウンター：配列timeで使う
    @State private var currentIndex: Int = 0
    let soundPlayer = SoundPlayer()
    var densityLabel: DensityLevel {
        DensityLevel(rawValue: dripData.settings.kosa) ?? .普通
    }
    var body: some View {

        NavigationStack {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 10.0){
                    HStack{
                        Group {
                            Text("豆")
                            Text("\(Int(dripData.settings.mame))")
                            Text("g")
                            Text(verbatim: "ー濃さ")
                            Text(verbatim: String(describing: densityLabel))
                        }
                    }//豆・濃さ表示
                    .font(.title)
                    ZStack {
                        ProgressBar(progress: timervalue - count, initial: timervalue)
                            .frame(width: 250)
                        VStack {
                            //                            Text("\(kaisu)回目のお湯")
                            ForEach(Array(dripData.ArrayHotW.enumerated()), id: \.offset) { idx, hotW in
                                let isCurrent = (idx + 1) == kaisu
                                let indexText = "\(idx + 1)回目"
                                let hotWText = String(format: "%3d", Int(hotW)) + "g"
                                let timeValue = dripData.settings.time[idx]
                                let timeText = "\(timeValue)秒"
                                Text(verbatim: "\(indexText)：\(hotWText)：\(timeText)")
                                    .font(.title2)
                                    .fontWeight(isCurrent ? .bold : .regular)
                                    .foregroundStyle(isCurrent ? Color.pink : Color.primary)
                                    .padding(.horizontal, isCurrent ? 4 : 0)
                                    .padding(.vertical, isCurrent ? 2 : 0)
                                    .background(
                                        Group {
                                            if isCurrent {
                                                Capsule().fill(Color.pink.opacity(0.15))
                                            }
                                        }
                                    )
                            }//ForEach
                        }//プログレスバーとZ重ねているところ
                    }//ZStack プログレスバーと豆・回数表示
                    HStack(spacing: 0) {
                        Text("残り")
                        Text("\(max(timervalue - count, 0))")
                        Text(" 秒")
                    }
                    .font(.title)
//スタート・ストップボタン
                    HStack{
                        Spacer()
                        Button{
                            startTimer()
                        } label: {
                            Text("スタート")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(width: 90,height: 90)
                                .background(in: Circle())
                                .backgroundStyle(Color("startColor"))
                        }
                        Spacer()
                        Button{
                            stopTimer()
                        } label: {
                            Text("ストップ")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .frame(width: 90,height: 90)
                                .background(in: Circle())
                                .backgroundStyle(Color("stopColor"))
                        }
                        Spacer()
                    }//HStack でButtonを配置
                }//VStack 画面構成がここまで
                .onAppear{
                    if !dripData.settings.time.isEmpty {
                        currentIndex = 0
                        timervalue = dripData.settings.time[currentIndex]
                        kaisu = currentIndex + 1
                        count = 0
                    }
                }//onApper
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink{
                            MameSetView(dripData: dripData)
                        } label: {
                            Text("Dripの設定")
                        }
                    }
                }//toolbar
                .alert("終了",isPresented: $showAlert) {
                    Button("Ok") {
                        if !dripData.settings.time.isEmpty {
                            currentIndex = 0
                            timervalue = dripData.settings.time[currentIndex]
                            kaisu = currentIndex + 1
                            count = 0
                        }
                    }
                }message: {
                    Text("ドリップ終了です。美味しいコーヒーはできましたか。")
                }//alert
            }//ZStack バックグラウンドを指定しているZ
        }//NavigationStack
    }//bar body: someView
    // ここで秒数を数える
    func countDownTimer() {
        count += 1
        if timervalue - count <= 0 {
            currentIndex += 1
            if currentIndex < dripData.settings.time.count {
                timervalue = dripData.settings.time[currentIndex]
                count = 0
                kaisu = currentIndex + 1
                soundPlayer.play()
            } else {
                kaisu = 0
                count = 0
                showAlert = true
                timerHandler?.invalidate()
                soundPlayer.play()
            }
        }//if　タイマーの残りが0になったら
    }//countDownTimer

    func startTimer() {
        if let unwrappedTimerHandler = timerHandler {
            if unwrappedTimerHandler.isValid == true {
                return//動いていたら何もしない
            }
        }
        if timervalue - count <= 0 {
            count = 0
        }
        if $dripData.settings.time.indices.contains(currentIndex) == false, !dripData.settings.time.isEmpty {
            currentIndex = 0
            timervalue = dripData.settings.time[currentIndex]
            kaisu = currentIndex + 1
            count = 0
        }
        //        タイマースタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countDownTimer()
        }
    }//startTimer

    func stopTimer() {
        if let unwrappedTimerHandler = timerHandler {
            if unwrappedTimerHandler.isValid == true {
                unwrappedTimerHandler.invalidate()
            }
        }
    }//stopTimer
}

#Preview {
    let previewDripData = DripData()//インスタンスはinit()で初期化したもの
    ContentView(dripData: previewDripData)
}
