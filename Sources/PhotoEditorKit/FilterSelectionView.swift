//
//  FilterSelectionView.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/12/24.
//

import SwiftUI

struct FilterSelectionView: View {
    var viewModel: PhotoEditorViewModel

    var body: some View {
        HStack {
            FilterButton(
                filter: FilterOption.brightness,
                isSelected: viewModel.activeFilter == FilterOption.brightness
            ) {
                viewModel.activeFilter = .brightness
            }

            FilterButton(
                filter: FilterOption.saturation,
                isSelected: viewModel.activeFilter == FilterOption.saturation
            ) {
                viewModel.activeFilter = .saturation
            }

            FilterButton(
                filter: FilterOption.contrast,
                isSelected: viewModel.activeFilter == FilterOption.contrast
            ) {
                viewModel.activeFilter = .contrast
            }

            FilterButton(
                filter: FilterOption.sharpen,
                isSelected: viewModel.activeFilter == FilterOption.sharpen
            ) {
                viewModel.activeFilter = .sharpen
            }
        }
    }
}
