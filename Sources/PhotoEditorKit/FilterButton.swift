//
//  FilterButton.swift
//  GPUImage3Learning
//
//  Created by Lu Ai on 2025/12/24.
//

import SwiftUI

struct FilterButton: View {
    let filter: FilterOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: filter.icon)
                    .font(.title2)

                Text(filter.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .accentColor : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
        }
        .buttonStyle(.plain)
    }
}
