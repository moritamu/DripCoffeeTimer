//
//  progressView.swift
//  sampleTimer1 Watch App
//
//  Created by MsMacM on 2024/01/13.
//

import SwiftUI

//これを多分別ファイルにしていい
struct ProgressBar: View {
    let progress: Int
    let initial: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15.0)
                .opacity(0.4)
                .foregroundColor(.indigo)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(Float(progress) / Float(initial), 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.indigo)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeIn, value: 1.0)//?????
        }
//        .onAppear(){
//            //            UIApplication.shared.isIdleTimerDisabled = false
//            
//        }
    }
}

#Preview {
    ProgressBar(progress: 6, initial: 10)
}
