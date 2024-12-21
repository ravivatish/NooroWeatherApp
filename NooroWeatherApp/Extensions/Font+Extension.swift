//
//  Font+Extension.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/19/24.
//

import SwiftUI

extension Font {
    static func poppins(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        
        switch weight {
        case .regular:
            fontName = "Poppins-Regular"
        case .bold:
            fontName = "Poppins-Bold"
        case .medium:
            fontName = "Poppins-SemiBold"
        default:
            fontName = "Poppins-Regular"
        }
        
        return .custom(fontName, size: size)
    }
}


