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
    let soundPlayer = SoundPlayer()

    var body: some View {

        NavigationStack {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 30.0){
                    ZStack {
                        ProgressBar(progress: timervalue - count, initial: timervalue)
                            .frame(width: 200,height: 200)
                        VStack {
                            Text("豆 \(Int(dripData.mame))g")
                            Text("\(kaisu)回目のお湯")
                                .font(.title2)
                            switch kaisu {
                            case 1:
//                                Text(String(format: "%.0f", dripData.hotWT * 0.2) + " g")
                                Text(String(format: "%.0f", dripData.ArrayHotW[0]) + " g")
                                    .font(.largeTitle)
                            case 2:
//                                Text(String(format: "%.0f", dripData.hotWT * 0.4) + " g")
                                Text(String(format: "%.0f", dripData.ArrayHotW[1]) + " g")
                                    .font(.largeTitle)
                            case 3:
//                                Text(String(format: "%.0f", dripData.hotWT) + " g")
                                Text(String(format: "%.0f", dripData.ArrayHotW[2]) + " g")
                                    .font(.largeTitle)
                            default://とりあえず書いておく
                                Text(String(format: "%.1f", dripData.hotWT))
                                    .font(.largeTitle)
                            }
                            Text("残り\(timervalue - count)秒")
                                .font(.headline)
                        }
                    }
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
                    }
                    HStack {
                        Text(String(format: "%.1f", dripData.mame) + " g ー ")
                        Text(String(format: "%.1f", dripData.hotWT) + " g")
                    }
                    .font(.headline)
                    Text(String(format: "%.1f", dripData.kosa)+" g/100ml")
                    HStack{
                        Text("1:  \(dripData.time[0]) 秒,")
                        Text("2:  \(dripData.time[1]) 秒,")
                        Text("3:  \(dripData.time[2]) 秒")
                    }
                }

                .onAppear{
                    timervalue = dripData.time[0]
                    kaisu = 1
                    count = 0
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink{
                            MameSetView(dripData: dripData)
                        } label: {
                            Text("設定")
                        }
                    }
                }
                .alert("終了",isPresented: $showAlert) {
                    Button("Ok") {
                        timervalue = dripData.time[0]
                        //                    print("Okがタップされました")
                    }
                }message: {
                    Text("ドリップ終了です。美味しいコーヒーはできましたか。")
                }
            }
        }
    }
    // ここで秒数を数える
    func countDownTimer() {
        count += 1
        if timervalue - count <= 0 {
            switch kaisu {
            case 1:
                timervalue = dripData.time[1]
                count = 0
                soundPlayer.play()
            case 2:
                timervalue = dripData.time[2]
                count = 0
                soundPlayer.play()
            case 3:
                kaisu = 0
                count = 0
                showAlert = true
                timerHandler?.invalidate()//Timer停止
                soundPlayer.play()
            default:
                break
            }
            kaisu += 1
        }
    }

    func startTimer() {
        if let unwrappedTimerHandler = timerHandler {
            if unwrappedTimerHandler.isValid == true {
                return//動いていたら何もしない
            }
        }
        if timervalue - count <= 0 {
            count = 0
        }
        //        タイマースタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countDownTimer()
        }
    }

    func stopTimer() {
        if let unwrappedTimerHandler = timerHandler {
            if unwrappedTimerHandler.isValid == true {
                unwrappedTimerHandler.invalidate()
            }
        }
    }
}

#Preview {
    ContentView(dripData: DripData(mame: 12.0, kosa: 6.0, time: [5,10,12]))
}
