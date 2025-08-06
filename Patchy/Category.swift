//
//  Category.swift
//  Patchy
//
//  Created by mar on 01.08.2025.
//


import Foundation


enum Category: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }

    case электрика = "Электрика"
    case сантехника = "Сантехника"
    case мебель = "Мебель"
    case отделка = "Отделка"
    case климат = "Климат"
    case other = "Прочее"
    
    var iconName: String {
        switch self {
        case .электрика: return "bolt.fill"
        case .сантехника: return "drop.fill"
        case .мебель: return "bed.double.fill"
        case .отделка: return "paintbrush.fill"
        case .климат: return "wind"
        case .other: return "wrench.fill"
        }
    }
}


func icon(for name: String) -> String {
      
    let category = Category(rawValue: name) ?? .other
          return category.iconName
   }

