//
//  DripData.swift
//  MyTimerTest1
//
//  Created by MsMacM on 2024/09/06.
//

import Foundation
import Observation

@Observable class DripData {
    var mame: Double = 12
    var kosa: Double = 6
    //    時間を配列で、例[45,45,45] [１回目,２回目,３回目,・・・]
    //    var time: Array<Any>　ここはもう少し修正できそう
    var time: [Int] = [60,60,60]

    var hotWT: Double {
        get {
            return mame / kosa * 100.0
        }
    }
    //注ぐお湯の量を配列で保存する。時間とタプルにしてもいい。今のところ、３回で入れる場合のみ
    var ArrayHotW: [Double] {
        return [hotWT * 0.2,hotWT * 0.4, hotWT]
    }
//classなのでイニシャライザが必要。
    init(mame: Double, kosa: Double, time: [Int]) {
        self.mame = mame
        self.kosa = kosa
        self.time = time
    }
    
}
