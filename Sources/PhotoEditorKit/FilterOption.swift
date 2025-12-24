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

    var title: String {
        switch self {
        case .brightness:
            String(localized: "Brightness", bundle: .module)
        case .contrast:
            String(localized: "Contrast", bundle: .module)
        case .saturation:
            String(localized: "Saturation", bundle: .module)
        case .sharpen:
            String(localized: "Sharpen", bundle: .module)
        }
    }
}
