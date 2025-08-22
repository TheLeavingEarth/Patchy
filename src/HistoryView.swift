////
//  HistoryView.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//
import SwiftUI


// История выполненных ремонтов
    struct HistoryView: View {
        @EnvironmentObject var store: RepairStore
        
        /// Только выполненные ремонты
        var completedRepairs: [Repair] {
            store.repairs.filter { $0.isCompleted }
        }

        var body: some View {
            NavigationView {
                List {
                    if completedRepairs.isEmpty {
                        Text("Нет выполненных ремонтов")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(completedRepairs) { repair in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: icon(for: repair.category))
                                        .foregroundColor(.blue)

                                    VStack(alignment: .leading) {
                                        Text(repair.title)
                                            .font(.headline)
                                        Text(repair.category)
                                            .font(.subheadline)
                                        Text(repair.date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    store.deleteRepairById(repair.id)
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("История")
            }
        }
    }

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let store = RepairStore()
        store.repairs = [
            Repair(title: "Починить кран", category: "Сантехника", date: Date(), description: "Заменена прокладка", isCompleted: true),
            Repair(title: "Поменять лампу", category: "Электрика", date: Date(), description: "Сгорела старая", isCompleted: true)
        ]

        return HistoryView()
            .environmentObject(store)
            .previewDevice("iPhone 14")
    }
}

