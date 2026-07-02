//
//  MyDripTimerApp.swift
//  MyDripTimer
//
//  Created by MsMacM on 2024/08/15.
//

import SwiftUI

@main
struct DripCoffeeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dripData: DripData(mame: 12.0, kosa: 6.0, time: [5,10,8]))
        }
    }
}
