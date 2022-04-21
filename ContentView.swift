//
//  ContentView.swift
//  LowerYourMouse
//
//  Created by Yoonjae on 2022/04/20.
//

import SwiftUI


let numberOfSamples: Int = 15

struct ContentView: View {
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    @State private var flag = true
        private func normalizeSoundLevel(level: Float) -> CGFloat {
            let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
            
            return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
        }
    
    
    var body: some View {
        VStack {
            HStack {
                GifImage("giphy")
                    .frame(width: 100, height: 100, alignment: .leading)
                    .padding(.leading,-10)
                    
                let formattedFloat = String(format: "%.1f", mic.soundSamples[0]+90)
                Text("My Voice: \(formattedFloat) dB")
                    .padding()
                    .font(.system(size: 40))
                
                
            }
            
            Spacer()
            HStack(spacing: 4) {
                             // 4
                            ForEach(mic.soundSamples, id: \.self) { level in
                                BarView(value: self.normalizeSoundLevel(level: level))
                            }
                    }
            Spacer()
            if mic.soundSamples[0] < -40 {
                Text("Great")
                    .padding()
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: 0xff8882))
            } else {
                Text("Lower your mouse")
                    .padding()
                    .font(.system(size: 40))
                    .foregroundColor(Color.red)
                
            }
            
        }
    }
}

struct BarView: View {
   // 1
    var value: CGFloat

    var body: some View {
        ZStack {
           // 2
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .purple]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                // 3
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
        }
    }
}



extension Float {
    var f : CGFloat { return CGFloat(self)}
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

