//
//  BlinkOverlayView.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI

struct BlinkOverlayView: View {
    
    let opacity: Double
    
    var body: some View {
        
        Color.black
            .opacity(opacity)
            .ignoresSafeArea()
    }
}
