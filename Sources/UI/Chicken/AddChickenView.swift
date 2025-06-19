import SwiftUI
import PhotosUI

struct AddChickenView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    @State private var name = ""
    @State private var notes = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Label("Foto auswählen", systemImage: "photo")
                }
                if let data = photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                TextField("Notiz", text: $notes, axis: .vertical)
            }
            .navigationTitle("Huhn anlegen")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern", action: save)
                        .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen", action: { dismiss() })
                }
            }
            .onChange(of: photoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }

    private func save() {
        let chicken = Chicken(context: context)
        chicken.id = UUID()
        chicken.name = name
        chicken.createdAt = .now
        chicken.photoData = photoData ?? Data()
        chicken.notes = notes.isEmpty ? nil : notes
        try? context.save()
        dismiss()
    }
}
