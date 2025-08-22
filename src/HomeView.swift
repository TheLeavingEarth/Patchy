import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: RepairStore
    @State private var showingAddView = false
    @State private var selectedRepair: Repair? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(store.filteredRepairs.filter { !$0.isCompleted }) { repair in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: icon(for: repair.category))
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(repair.title)
                                    .font(.headline)

                                Text(repair.category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text(repair.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button("Редактировать") {
                                selectedRepair = repair
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            var updated = repair
                            updated.isCompleted.toggle()
                            store.updateRepair(updated)
                        } label: {
                            Label("Завершить", systemImage: "checkmark")
                        }
                        .tint(.green)
                    }
                }
                .onDelete(perform: store.deleteRepair)
            }
            .navigationTitle("Мои ремонты")
            .searchable(text: $store.searchText, prompt: "Поиск по ремонтам")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                SimpleAddRepairView()
                    .environmentObject(store)
            }
            .sheet(item: $selectedRepair) { repair in
                EditRepairView(
                    repair: repair,
                    onSave: { updatedRepair in
                        store.updateRepair(updatedRepair)
                    },
                    onDelete: {
                        store.deleteRepairById(repair.id)
                    }
                )
                .environmentObject(store)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(RepairStore())
    }
}
