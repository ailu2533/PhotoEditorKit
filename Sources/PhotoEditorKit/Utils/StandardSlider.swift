//
//  StandardSlider.swift
//  PhotoEditorKit
//
//  Created by Lu Ai on 2025/12/25.
//

import SwiftUI

public struct StandardSlider: View {
    @Binding var value: Int
    let bounds: ClosedRange<Int>
    let step: Int

    @GestureState private var isDragging = false

    public init(value: Binding<Int>, bounds: ClosedRange<Int>, step: Int = 1) {
        _value = value
        self.bounds = bounds
        self.step = step
    }

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 24
            let trackHeight: CGFloat = 8

            // Calculate position
            let currentX = xPosition(for: Double(value), width: width, thumbSize: thumbSize)

            ZStack(alignment: .leading) {
                // Track background
                RoundedRectangle(cornerRadius: trackHeight / 2)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: trackHeight)

                // Active Track Segment (fills from left)
                RoundedRectangle(cornerRadius: trackHeight / 2)
                    .fill(Color.accentColor)
                    .frame(width: currentX + (thumbSize / 2), height: trackHeight) // Extend slightly under thumb

                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(radius: 2)
                    .overlay {
                        if isDragging {
                            Text(value, format: .number)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(4)
                                .offset(y: -thumbSize - 10)
                                .fixedSize()
                        }
                    }
                    .offset(x: currentX - thumbSize / 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .updating($isDragging) { _, state, _ in
                                state = true
                            }
                            .onChanged { gesture in
                                let newValue = updateValue(for: gesture.location.x, in: width, thumbSize: thumbSize)
                                if value != newValue {
                                    value = newValue
                                }
                            }
                    )
            }
        }
        .frame(height: 24)
    }

    private func xPosition(for v: Double, width: CGFloat, thumbSize: CGFloat) -> CGFloat {
        let minVal = Double(bounds.lowerBound)
        let maxVal = Double(bounds.upperBound)
        let range = maxVal - minVal

        let clampedValue = min(max(v, minVal), maxVal)
        let percent = range == 0 ? 0 : (clampedValue - minVal) / range
        let availableWidth = width - thumbSize
        return (thumbSize / 2) + percent * availableWidth
    }

    private func updateValue(for xPosition: CGFloat, in width: CGFloat, thumbSize: CGFloat) -> Int {
        let availableWidth = width - thumbSize
        let adjustedX = xPosition - (thumbSize / 2)
        let percentage = min(max(adjustedX / availableWidth, 0), 1)

        let minVal = Double(bounds.lowerBound)
        let maxVal = Double(bounds.upperBound)
        let range = maxVal - minVal

        let newValue = minVal + (percentage * range)
        let stepDouble = Double(step)
        let steppedValue = round(newValue / stepDouble) * stepDouble
        return Int(min(max(steppedValue, minVal), maxVal))
    }
}

#Preview {
    @Previewable @State var value = 50

    StandardSlider(value: $value, bounds: 0 ... 100, step: 1)
        .padding()
}
