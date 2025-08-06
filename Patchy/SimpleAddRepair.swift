//
//  SimpleAddRepair.swift
//  Patchy
//
//  Created by mar on 20.07.2025.
//


import SwiftUI
import PhotosUI

struct SimpleAddRepairView: View {
    @EnvironmentObject var store: RepairStore
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var reminderDate: Date? = nil
    @State private var showReminderPicker = false

    var body: some View {
        NavigationView {
            Form {
                // Категория
                Section(header: Text("Категория")) {
                    Menu {
                        ForEach(Category.allCases) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Label(category.rawValue, systemImage: category.iconName)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Выбрать")
                            Spacer()
                            if let selected = selectedCategory {
                                Label(selected.rawValue, systemImage: selected.iconName)
                                    .labelStyle(.titleAndIcon)
                            } else {
                               
                            }
                        }
                    }
                }

                // Название и описание
                Section(header: Text("Информация")) {
                    TextField("Название", text: $title)
                    TextField("Описание", text: $description)
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                }

                // Напоминание
                Section(header: Text("Напоминание")) {
                    Toggle("Установить напоминание", isOn: $showReminderPicker.animation())
                    if showReminderPicker {
                        DatePicker(
                            "Дата",
                            selection: Binding(
                                get: { reminderDate ?? Date() },
                                set: { reminderDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }

                // Фото
                Section(header: Text("Фото")) {
                    PhotosPicker("Выбрать фото", selection: $selectedItem, matching: .images)
                    
                    if let data = selectedImageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Добавить ремонт")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        guard let selectedCategory = selectedCategory else { return }
                        let newRepair = Repair(
                            title: title,
                            category: selectedCategory.rawValue,
                            date: date,
                            description: description,
                            photoData: selectedImageData,
                            reminderDate: reminderDate
                        )
                        store.addRepair(newRepair)
                        store.scheduleNotification(for: newRepair)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || selectedCategory == nil)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
}

    
    struct  SimpleAddRepairView_Prewiews: PreviewProvider {
        static var previews: some View {
            SimpleAddRepairView()
                .environmentObject(RepairStore())
        }
    }
    
    

