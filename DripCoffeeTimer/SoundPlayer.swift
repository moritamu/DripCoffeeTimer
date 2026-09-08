//
//  SoundPlayer.swift
//  MyTimerTest1
//
//  Created by MsMacM on 2024/11/17.
//

import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    var player: AVAudioPlayer!

    func play(soundName: String) {
        let musicData = NSDataAsset(name: soundName)!.data
        player = try! AVAudioPlayer(data: musicData)
        player.play()
    }
}

