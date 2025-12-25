//
//  FilterButtonsSection.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/12/24.
//

import SwiftUI

struct FilterButtonsSection: View {
    @Bindable var viewModel: PhotoEditorViewModel

    var body: some View {
        VStack {
            switch viewModel.activeFilter {
            case .brightness:
                GeneralSlider(viewModel: viewModel, filter: FilterOption.brightness, value: $viewModel.brightness, range: -100 ... 100)
            case .contrast:
                GeneralSlider(viewModel: viewModel, filter: FilterOption.contrast, value: $viewModel.contrast, range: -100 ... 100)
            case .saturation:
                GeneralSlider(viewModel: viewModel, filter: FilterOption.saturation, value: $viewModel.saturation, range: -100 ... 100)
            case .sharpen:
                GeneralSlider(viewModel: viewModel, filter: FilterOption.sharpen, value: $viewModel.sharpness, range: 0 ... 100)
            case .none:
                GeneralSlider(viewModel: viewModel, filter: FilterOption.sharpen, value: $viewModel.sharpness, range: 0 ... 100)
                    .opacity(0)
            }

            FilterSelectionView(viewModel: viewModel)
        }
    }
}
