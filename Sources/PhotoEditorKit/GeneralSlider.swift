import SwiftUI

struct GeneralSlider: View {
    var viewModel: PhotoEditorViewModel

    var filter: FilterOption
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        Group {
            if range.lowerBound >= 0 {
                StandardSlider(
                    value: $value,
                    bounds: range
                )
            } else {
                SymmetricSlider(
                    value: $value,
                    bounds: range
                )
            }
        }
        .onThrottle(of: value) { _ in
            Task {
                await viewModel.applyCurrentFilters()
            }
        }
    }
}
