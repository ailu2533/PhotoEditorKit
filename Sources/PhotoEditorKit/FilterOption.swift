//
//  FilterOption.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/12/24.
//

import Foundation

enum FilterOption: String, CaseIterable {
    case brightness = "Brightness"
    case contrast = "Contrast"
    case saturation = "Saturation"
    case sharpen = "Sharpen"

    var icon: String {
        switch self {
        case .brightness: "sun.max"
        case .contrast: "circle.lefthalf.filled"
        case .saturation: "paintpalette"
        case .sharpen: "triangle"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .brightness:
            LocalizedStringResource("Brightness", bundle: .main)
        case .contrast:
            LocalizedStringResource("Contrast", bundle: .main)
        case .saturation:
            LocalizedStringResource("Saturation", bundle: .main)
        case .sharpen:
            LocalizedStringResource("Sharpen", bundle: .main)
        }
    }
}
