
import SwiftUI

struct PhotoEditorView: View {
    @State private var viewModel: PhotoEditorViewModel

    let onSave: (UIImage) -> Void

    @Environment(\.dismiss)
    private var dismiss

    init(image: UIImage, onSave: @escaping (UIImage) -> Void) {
        _viewModel = State(initialValue: PhotoEditorViewModel(originalImage: image))
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            VStack {
                // Image Display Area
                Image(uiImage: viewModel.processedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                FilterButtonsSection(viewModel: viewModel)
            }
            .padding()
//            .navigationTitle("Photo Editor")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(viewModel.processedImage)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
