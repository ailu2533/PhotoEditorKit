//
//  PhotoEditorViewModel.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/11/17.
//

import Observation
import SwiftUI

/// ViewModel for interactive photo editing with real-time filter adjustments
@MainActor
@Observable
class PhotoEditorViewModel {
    // MARK: - Properties

    var originalImage: UIImage
    var processedImage: UIImage
    var isProcessing = false

    // Filter parameters (range: -100 to 100, 0 = no change)
    var brightness: Int = 0
    var contrast: Int = 0
    var saturation: Int = 0
    var sharpness: Int = 0

    // Active filter selection
    var activeFilter: FilterOption?

    init(originalImage: UIImage) {
        self.originalImage = originalImage
        processedImage = originalImage
    }

    /// Reset filter parameters to default values
    func resetParameters() {
        brightness = 0
        contrast = 0
        saturation = 0
        sharpness = 0
    }

    /// Apply filter immediately without debounce (for filter type changes)
    func applyCurrentFilters() async {
        await processImage(originalImage)
    }

    // MARK: - Parameter Mapping

    /// Map brightness from -100...100 to -1.0...1.0
    private func mapBrightness(_ value: Int) -> Float {
        Float(value) / 100.0
    }

    /// Map contrast from -100...100 to 0.0...4.0 (0 maps to 1.0)
    private func mapContrast(_ value: Int) -> Float {
        if value >= 0 {
            // 0...100 maps to 1.0...4.0
            1.0 + (Float(value) / 100.0) * 3.0
        } else {
            // -100...0 maps to 0.0...1.0
            1.0 + (Float(value) / 100.0)
        }
    }

    /// Map saturation from -100...100 to 0.0...2.0 (0 maps to 1.0)
    private func mapSaturation(_ value: Int) -> Float {
        if value >= 0 {
            // 0...100 maps to 1.0...2.0
            1.0 + (Float(value) / 100.0)
        } else {
            // -100...0 maps to 0.0...1.0
            1.0 + (Float(value) / 100.0)
        }
    }

    /// Map sharpness from -100...100 to -4.0...4.0
    private func mapSharpness(_ value: Int) -> Float {
        Float(value) / 100.0 * 4.0
    }

    /// Process the image with cumulative filters
    private func processImage(_ image: UIImage) async {
        isProcessing = true

        // Capture and map all parameter values
        let brightnessInt = brightness
        let contrastInt = contrast
        let saturationInt = saturation
        let sharpnessInt = sharpness

        let brightnessValue = mapBrightness(brightnessInt)
        let contrastValue = mapContrast(contrastInt)
        let saturationValue = mapSaturation(saturationInt)
        let sharpnessValue = mapSharpness(sharpnessInt)

        // Build array of filters to apply (only non-zero values)
        var filters: [ImageFilterProcessor.FilterType] = []

        if brightnessInt != 0 {
            filters.append(.brightness(brightnessValue))
        }
        if contrastInt != 0 {
            filters.append(.contrast(contrastValue))
        }
        if saturationInt != 0 {
            filters.append(.saturation(saturationValue))
        }
        if sharpnessInt != 0 {
            filters.append(.sharpen(sharpnessValue))
        }

        // Apply filters
        let result = await ImageFilterProcessor.applyFilters(filters, to: image)

        // Update UI on main actor
        if let result {
            processedImage = result
        } else {
            processedImage = image
        }
        isProcessing = false
    }

    /// Reset to original image
    func reset() {
        activeFilter = nil
        resetParameters()
        processedImage = originalImage
    }
}
