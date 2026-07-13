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

import SwiftUI

struct ContentView: View {
    @State var timerHandler: Timer?
    @State var count = 0

    //      timerValueは@AppStorageで設定読み込み
    //    @AppStorage("timer_value") var timervalue = 10

    @State var timervalue: Int = 10
    @State var showAlert = false
    @State var kaisu = 0
    @State var dripData: DripData
    //お湯を入れるのが何回めかのカウンター：配列timeで使う
    @State private var currentIndex: Int = 0
    let soundPlayer = SoundPlayer()

    var body: some View {

        NavigationStack {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 25.0){
                    ZStack {
                        ProgressBar(progress: timervalue - count, initial: timervalue)
                            .frame(width: 200,height: 200)
                        VStack {
                            Text("豆　\(Int(dripData.mame))g")
//                                .font(.title)
                                .padding(10)
                            //                            Text("\(kaisu)回目のお湯")
                            ForEach(Array(dripData.ArrayHotW.enumerated()), id: \.offset) { idx, hotW in
                                Text("\(idx+1)回目：\(String(format: "%3d", Int(hotW)))g")
                                    .font(.headline)
                            }
                        }
                    }
                    Text("残り\(max(timervalue - count, 0)) 秒")//プログレス円バーの下に表示
                        .font(.headline)
                    HStack{//スタート・ストップボタン
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
                    HStack {
                        Text(String(format: "%.1f", dripData.mame) + " g ー ")
                        Text(String(format: "%.1f", dripData.hotWT) + " g")
                    }
                    .font(.headline)
                    Text(String(format: "%.1f", dripData.kosa)+" g/100ml")
                    HStack{
                        ForEach(Array(dripData.time.enumerated()), id: \.offset) { idx, t in
                            if idx > 0 { Text(",")}
                            Text("\(idx + 1):  \(t) 秒")
                        }//ForEach
                    }//HStack
                }//VStack 30

                .onAppear{
                    if !dripData.time.isEmpty {
                        currentIndex = 0
                        timervalue = dripData.time[currentIndex]
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
                        if !dripData.time.isEmpty {
                            currentIndex = 0
                            timervalue = dripData.time[currentIndex]
                            kaisu = currentIndex + 1
                            count = 0
                        }
                    }
                }message: {
                    Text("ドリップ終了です。美味しいコーヒーはできましたか。")
                }//alert
            }//ZStack
        }//NavigationStack
    }//someView
    // ここで秒数を数える
    func countDownTimer() {
        count += 1
        if timervalue - count <= 0 {
            currentIndex += 1
            if currentIndex < dripData.time.count {
                timervalue = dripData.time[currentIndex]
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
        if dripData.time.indices.contains(currentIndex) == false, !dripData.time.isEmpty {
            currentIndex = 0
            timervalue = dripData.time[currentIndex]
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
    ContentView(dripData: DripData(mame: 12.0, kosa: 6.0, time: [5,6,7]))
}

