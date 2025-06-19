import SwiftUI
import SwiftUI

@main
struct ChickInnApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                persistenceController.saveIfNeeded()
            }
        }
    }
}
