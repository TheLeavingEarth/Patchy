//
//  MainTabView.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//

import SwiftUI

/// Основной контейнер с вкладками (TabView)
/// 
struct MainTabView: View {
    @EnvironmentObject var store: RepairStore
    
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
            
            
            HistoryView(store: _store)
                .tabItem {
                    Label("История", systemImage: "clock.fill")
                }
            
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .environmentObject(store) //
    }
    
    

        struct AllScreens_Previews: PreviewProvider {
            static var previews: some View {
                let store = RepairStore()

                Group {
                    HomeView()
                        .previewDisplayName("Главная")

                 

                    HistoryView()
                        .previewDisplayName("История")

                    SimpleAddRepairView()
                        .previewDisplayName("Добавить ремонт")

                    SettingsView()
                        .previewDisplayName("Настройки")
                }
                .previewDevice("iPhone 14")
                .environmentObject(store)
            }
        }
        
}
