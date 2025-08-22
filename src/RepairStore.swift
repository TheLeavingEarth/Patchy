//
//  RepairStore.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//

import Foundation
import SwiftUI
import UserNotifications

/// Хранилище ремонтов
class RepairStore: ObservableObject {
    @Published var repairs: [Repair] = []
    @Published var searchText: String = ""
    
    

    func addRepair(_ repair: Repair) {
        repairs.append(repair)
        saveToFile()
        scheduleNotification(for: repair)
    }

    func deleteRepair(at offsets: IndexSet) {
        let deleted = offsets.map { repairs[$0] }
        repairs.remove(atOffsets: offsets)
        saveToFile()
        deleted.forEach { removeScheduledNotification(for: $0) }
    }

    func updateRepair(_ repair: Repair) {
        if let index = repairs.firstIndex(where: { $0.id == repair.id }) {
            repairs[index] = repair
            saveToFile()
            removeScheduledNotification(for: repair)
            scheduleNotification(for: repair)
        }
    }

    func toggleCompletion(for repair: Repair) {
        if let index = repairs.firstIndex(where: { $0.id == repair.id }) {
            repairs[index].isCompleted.toggle()
            saveToFile()
        }
    }

    // MARK: - Поиск и фильтрация

    var filteredRepairs: [Repair] {
        if searchText.isEmpty {
            return repairs
        } else {
            return repairs.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    //  Хранение в JSON

    private let fileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("repairs.json")

    func saveToFile() {
        if let data = try? JSONEncoder().encode(repairs) {
            try? data.write(to: fileURL)
        }
    }

    func loadFromFile() {
        if let data = try? Data(contentsOf: fileURL),
           let savedRepairs = try? JSONDecoder().decode([Repair].self, from: data) {
            repairs = savedRepairs
        }
    }

    //  - Уведомления

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка разрешения уведомлений: \(error.localizedDescription)")
            } else {
                print("Разрешение на уведомления: \(granted)")
            }
        }
    }
    
    init() {
        loadFromFile()
    }

    func scheduleNotification(for repair: Repair) {
        
        guard let reminderDate = repair.reminderDate else { return }

        let content = UNMutableNotificationContent()
        content.title = "Напоминание о ремонте"
        content.body = "Не забудьте: \(repair.title)"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminderDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: repair.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка уведомления: \(error.localizedDescription)")
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Ошибка запроса разрешения: \(error)")
            }
        }
    }
    

    func removeScheduledNotification(for repair: Repair) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [repair.id.uuidString])
    }
    
    func deleteRepairById(_ id: UUID) {
        if let index = repairs.firstIndex(where: { $0.id == id }) {
            repairs.remove(at: index)
            saveToFile()
        }
    }

}
