//
//  ImageFilterProcessor.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/11/17.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

/// Global actor for isolating image processing operations
@globalActor
actor ImageProcessingActor {
    static let shared = ImageProcessingActor()
}

/// A helper class to process images using Core Image filters
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

    /// Apply multiple filters using Core Image
    static func applyFilters(_ filterTypes: [FilterType], to image: UIImage) -> UIImage? {
        guard !filterTypes.isEmpty else {
            return image
        }

        guard let cgImage = image.cgImage else {
            return nil
        }

        let ciImage = CIImage(cgImage: cgImage)
        var currentImage = ciImage
        
        let context = CIContext()

        for filterType in filterTypes {
            switch filterType {
            case let .brightness(value):
                let filter = CIFilter.colorControls()
                filter.inputImage = currentImage
                filter.brightness = value
                if let output = filter.outputImage {
                    currentImage = output
                }

            case let .contrast(value):
                let filter = CIFilter.colorControls()
                filter.inputImage = currentImage
                filter.contrast = value
                if let output = filter.outputImage {
                    currentImage = output
                }

            case let .saturation(value):
                let filter = CIFilter.colorControls()
                filter.inputImage = currentImage
                filter.saturation = value
                if let output = filter.outputImage {
                    currentImage = output
                }

            case let .gaussianBlur(radius):
                let filter = CIFilter.gaussianBlur()
                filter.inputImage = currentImage
                filter.radius = radius
                if let output = filter.outputImage {
                    currentImage = output.cropped(to: ciImage.extent)
                }

            case let .sharpen(sharpness):
                let filter = CIFilter.sharpenLuminance()
                filter.inputImage = currentImage
                filter.sharpness = sharpness
                if let output = filter.outputImage {
                    currentImage = output
                }

            case let .sepia(intensity):
                let filter = CIFilter.sepiaTone()
                filter.inputImage = currentImage
                filter.intensity = intensity
                if let output = filter.outputImage {
                    currentImage = output
                }

            case .grayscale:
                let filter = CIFilter.photoEffectMono()
                filter.inputImage = currentImage
                if let output = filter.outputImage {
                    currentImage = output
                }
            }
        }

        guard let resultCGImage = context.createCGImage(currentImage, from: currentImage.extent) else {
            return nil
        }

        return UIImage(cgImage: resultCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
