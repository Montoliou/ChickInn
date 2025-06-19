import Foundation
import CoreData

/// Singleton wrapper around a purely local Core Data stack (SQLite in Documents)
final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ChickInn")

        if inMemory {
            // Unit‑Tests: store in RAM
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else if let description = container.persistentStoreDescriptions.first {
            description.type = NSSQLiteStoreType
            description.url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("ChickInn.sqlite")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data error \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Persist pending changes when the app goes to background
    func saveIfNeeded() {
        let ctx = container.viewContext
        if ctx.hasChanges {
            try? ctx.save()
        }
    }
}
