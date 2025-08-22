//
//  EditRepairView.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct EditRepairView: View {
    @Environment(\.dismiss) var dismiss
    @State var repair: Repair
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil

    var onSave: (Repair) -> Void
    var onDelete: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основное")) {
                    TextField("Название", text: $repair.title)
                    TextField("Категория", text: $repair.category)
                    DatePicker("Дата", selection: $repair.date, displayedComponents: .date)
                    
                    TextEditor(text: $repair.description)
                        .frame(height: 100)
                }

                Section(header: Text("Фото")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Label("Выбрать фото", systemImage: "photo")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                image = uiImage
                                repair.photoData = data
                            }
                        }
                    }
                }

                Section {
                    Toggle("Выполнено", isOn: $repair.isCompleted)
                }

                // 🔴 Кнопка удаления
                Section {
                    Button("Удалить", role: .destructive) {
                        onDelete()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Редактирование")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave(repair)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditRepairView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditRepairView(
                repair: Repair(
                    title: "Починка крана",
                    category: "Сантехника",
                    date: Date(),
                    description: "Заменить прокладку",
                    photoData: nil
                ),
                onSave: { _ in },
                onDelete: {}
            )
        }
        .previewDevice("iPhone 14")
    }
}

