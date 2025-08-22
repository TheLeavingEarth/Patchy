//
//  SettingsView.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//

import SwiftUI

/// Экран настроек
struct SettingsView: View {
    @EnvironmentObject var store: RepairStore
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $isDarkMode) {
                    Text("Тёмная тема")
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(RepairStore())


    }
}
