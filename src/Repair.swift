//
//  RepairModel.swift
//  Patchy
//
//  Created by mar on 19.07.2025.
//

import Foundation


/// Модель ремонта
struct Repair: Identifiable, Codable {
    var id = UUID()
    var title: String
    var category: String
    var date: Date
    var description: String
    var photoData: Data?
    var isCompleted: Bool = false
    var reminderDate: Date? = nil
    
}

extension Repair {
    static func newBlank() -> Repair {
        return Repair(
            title: "",
            category: "",
            date: Date(),
            description: "",
            photoData: nil,
            isCompleted: false
            
        )
    }
}
