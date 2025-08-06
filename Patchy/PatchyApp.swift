//
//  PatchyApp.swift
//  Patchy
//
//  Created by mar on 16.07.2025.
//
import SwiftUI
import UserNotifications

@main
struct PatchyApp: App {
    @StateObject private var store = RepairStore()
    @AppStorage("isDarkMode") private var isDarkMode = false

    init() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
        ) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }

    
    @ViewBuilder
    private func RootView() -> some View {
        MainTabView()
            .environmentObject(store)
            .preferredColorScheme(isDarkMode ? ColorScheme.dark : ColorScheme.light)
    }
}
