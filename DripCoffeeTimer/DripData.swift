//
//  DripData.swift
//  MyTimerTest1
//
//  Created by MsMacM on 2024/09/06.
//

import Foundation
import Observation

//保存するデータ構造を定義（Codableに準拠）
struct DripSettings: Codable {
    var mame: Double = 12
    var kosa: Double = 6
    var time: [Int] = [60,60,60]
    //    時間を配列で、例[45,45,45] [１回目,２回目,３回目,・・・]
}
    //  ここでkosaを列挙型で定義しておく
enum DensityLevel: Double, CaseIterable, Identifiable {
    case 薄い = 5.0
    case 普通 = 6.0
    case やや濃い = 7.0
    case 濃い = 8.0

    var id: Double { self.rawValue }
    var label: String { String(describing: self) }
    var value: Double { self.rawValue }
}

@Observable class DripData {
    var settings: DripSettings
    private let settingsKey = "drip_settings_key"

    var hotWT: Double {
        get {
            return settings.mame / settings.kosa * 100.0
        }
    }
    //注ぐお湯の量を配列で保存する。時間とタプルにしてもいい。今のところ、３回で入れる場合のみ
    var ArrayHotW: [Double] {
        return [hotWT * 0.2,hotWT * 0.4, hotWT]
    }
    //classなのでイニシャライザが必要。
    init() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(DripSettings.self, from: data) {
            settings = decoded
        } else {
            settings = DripSettings()
        }
    }
    func saveSettinds() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
}
