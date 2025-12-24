//
//  ImageFilterProcessor.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/11/17.
//

import GPUImage
import UIKit

/// Global actor for isolating image processing operations
@globalActor
actor ImageProcessingActor {
    static let shared = ImageProcessingActor()
}

/// A helper class to process images using GPUImage3 filters
@ImageProcessingActor
class ImageFilterProcessor {
    // MARK: - Filter Types

    enum FilterType {
        case brightness(Float)
        case contrast(Float)
        case saturation(Float)
        case gaussianBlur(Float)
        case sharpen(Float)
        case sepia(Float)
        case grayscale
    }

    // MARK: - Processing Methods

    /// Apply multiple filters in a GPU pipeline (single pass)
    static func applyFilters(_ filterTypes: [FilterType], to image: UIImage) -> UIImage? {
        guard !filterTypes.isEmpty else {
            return image
        }

        guard let cgImage = image.cgImage else {
            return nil
        }

        // Create input
        let pictureInput = PictureInput(image: cgImage)

        // Create output
        let pictureOutput = PictureOutput()

        // Variable to track the last source in the chain
        var lastSource: ImageSource = pictureInput

        // Build the chain dynamically
        for (index, filterType) in filterTypes.enumerated() {
            switch filterType {
            case let .brightness(value):
                let filter = BrightnessAdjustment()
                filter.brightness = value
                lastSource --> filter
                lastSource = filter

            case let .contrast(value):
                let filter = ContrastAdjustment()
                filter.contrast = value
                lastSource --> filter
                lastSource = filter

            case let .saturation(value):
                let filter = SaturationAdjustment()
                filter.saturation = value
                lastSource --> filter
                lastSource = filter

            case let .gaussianBlur(radius):
                let filter = GaussianBlur()
                filter.blurRadiusInPixels = radius
                lastSource --> filter
                lastSource = filter

            case let .sharpen(sharpness):
                let filter = Sharpen()
                filter.sharpness = sharpness
                lastSource --> filter
                lastSource = filter

            case let .sepia(intensity):
                let filter = SepiaToneFilter()
                filter.intensity = intensity
                lastSource --> filter
                lastSource = filter

            case .grayscale:
                let filter = Luminance()
                lastSource --> filter
                lastSource = filter
            }
        }

        // Connect the last filter to output
        lastSource --> pictureOutput

        // Variable to capture the filtered image
        var filteredImage: UIImage?

        // Set up callback to capture the image
        pictureOutput.imageAvailableCallback = { image in
            filteredImage = image
        }

        // Process the entire pipeline synchronously (single GPU pass)
        pictureInput.processImage(synchronously: true)

        // Check if we got the filtered image
        guard let result = filteredImage else {
            return nil
        }

        return result
    }
}
