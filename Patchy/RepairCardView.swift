import SwiftUI

struct RepairCardView: View {
    let repair: Repair

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Иконка категории
            Image(systemName: categoryIcon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 32)

            // Фото ремонта или иконка
            if let image = repairImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }

            // Информация
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(repair.title)
                        .font(.headline)
                    if repair.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }

                Text(repair.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }

    /// Извлекаем фото, если есть
    private var repairImage: Image? {
        if let data = repair.photoData,
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }

    /// Дата как строка
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: repair.date)
    }

    /// Иконка категории
    private var categoryIcon: String {
        let category = Category(rawValue: repair.category) ?? Category.other
        return category.iconName
    }
}

struct RepairCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepairCardView(repair: Repair(
                title: "Заменить кран",
                category: "Сантехника",
                date: Date(),
                description: "На кухне течёт кран",
                isCompleted: true
            ))

            RepairCardView(repair: Repair(
                title: "Покрасить стены",
                category: "Покраска",
                date: Date(),
                description: "Гостиная",
                isCompleted: false
            ))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
