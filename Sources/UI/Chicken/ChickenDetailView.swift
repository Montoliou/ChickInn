//
//  ChickenDetailView.swift
//  ChickInn
//
//  Created by Andreas Peters on 19.06.25.
//

import SwiftUI
import CoreData

// MARK: - Snapshot value-types
private struct EggSnapshot: Identifiable {
    let id: NSManagedObjectID
    let laidAt: Date
}
private struct MoultSnapshot: Identifiable {
    let id: NSManagedObjectID
    let startDate: Date
    let endDate: Date?
}
private struct MedSnapshot: Identifiable {
    let id: NSManagedObjectID
    let name: String
    let startDate: Date
    let endDate: Date?
    let notes: String?
}

// MARK: - Helper‑Extension (safe Core Data access)
extension Chicken {
    //  Using `compactMap` on the underlying `NSSet` avoids the costly
    //  Set‑bridging that tries to `copy` every managed object and crashes.
    fileprivate func eggSnaps() -> [EggSnapshot] {
        (eggs as NSSet).compactMap { $0 as? Egg }
            .sorted { $0.laidAt > $1.laidAt }
            .map { EggSnapshot(id: $0.objectID,
                               laidAt: $0.laidAt) }
    }

    fileprivate func moultSnaps() -> [MoultSnapshot] {
        (moultings as NSSet).compactMap { $0 as? MoultPeriod }
            .sorted { $0.startDate > $1.startDate }
            .map { MoultSnapshot(id: $0.objectID,
                                 startDate: $0.startDate,
                                 endDate: $0.endDate) }
    }

    fileprivate func medSnaps() -> [MedSnapshot] {
        (medications as NSSet).compactMap { $0 as? Medication }
            .sorted { $0.startDate > $1.startDate }
            .map { MedSnapshot(id: $0.objectID,
                               name: $0.name,
                               startDate: $0.startDate,
                               endDate: $0.endDate,
                               notes: $0.notes) }
    }
}

// MARK: - Detail View
struct ChickenDetailView: View {
    @Environment(\.managedObjectContext) private var ctx
    let chickenID: NSManagedObjectID           // ← kommt aus ListView

    @State private var chicken: Chicken?

    var body: some View {
        Group {
            if let chicken {
                Form {
                    Section("Eier") {
                        ForEach(chicken.eggSnaps()) { egg in
                            Text(egg.laidAt.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                    Section("Mauser") {
                        ForEach(chicken.moultSnaps()) { m in
                            let end = m.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "läuft"
                            Text("\(m.startDate.formatted(date: .abbreviated, time: .omitted)) – \(end)")
                        }
                    }
                    Section("Medikation") {
                        ForEach(chicken.medSnaps()) { med in
                            VStack(alignment: .leading) {
                                Text(med.name).bold()
                                Text("\(med.startDate.formatted(date: .abbreviated, time: .omitted)) – \(med.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .navigationTitle(chicken.name ?? "Huhn")
            } else {
                ProgressView()
                    .task {
                        chicken = try? ctx.existingObject(with: chickenID) as? Chicken
                    }
            }
        }
    }
}
