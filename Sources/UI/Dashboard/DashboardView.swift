import SwiftUI
import CoreData
import UIKit

struct DashboardView: View {
    @FetchRequest(
        entity: Egg.entity(),
        sortDescriptors: [NSSortDescriptor(key: "laidAt", ascending: false)],
        animation: .default)
    private var eggs: FetchedResults<Egg>

    @FetchRequest(
        entity: Chicken.entity(),
        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)],
        animation: .default)
    private var chickens: FetchedResults<Chicken>

    @State private var todayCount = 0
    @State private var weekCount = 0
    @State private var monthCount = 0
    @State private var yearCount = 0

    // MARK: - Extracted sub‑views to help the Swift type‑checker
    @ViewBuilder
    private var gallerySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(chickens) { chicken in
                    chickenButton(for: chicken)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var statsSection: some View {
        KPIGrid(todayCount: todayCount,
                week: weekCount,
                month: monthCount,
                year: yearCount)
    }

    @ViewBuilder
    private func chickenButton(for chicken: Chicken) -> some View {
        Button {
            addEgg(for: chicken)
        } label: {
            if let uiImg = UIImage(data: chicken.photoData),
               uiImg.size != .zero {
                Image(uiImage: uiImg)
                    .resizable()
            } else {
                Image(systemName: "bird")
                    .resizable()
                    .foregroundStyle(Color.accentColor)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
        .accessibilityLabel("Ei bei \(chicken.name) hinzufügen")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    gallerySection
                    statsSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .onAppear(perform: calculateStats)
        }
    }

    private func addEgg(for chicken: Chicken) {
        guard let ctx = chicken.managedObjectContext else { return }
        let egg = Egg(context: ctx)
        egg.id = UUID()
        egg.laidAt = .now
        egg.chicken = chicken
        try? ctx.save()
        calculateStats()
    }

    private func calculateStats() {
        let cal = Calendar.current
        let now = Date()
        todayCount = eggs.filter { cal.isDate($0.laidAt, inSameDayAs: now) }.count
        weekCount  = eggs.filter { cal.isDate($0.laidAt, equalTo: now, toGranularity: .weekOfYear) }.count
        monthCount = eggs.filter { cal.isDate($0.laidAt, equalTo: now, toGranularity: .month) }.count
        yearCount  = eggs.filter { cal.isDate($0.laidAt, equalTo: now, toGranularity: .year) }.count
    }
}

private struct KPIGrid: View {
    let todayCount: Int
    let week: Int
    let month: Int
    let year: Int

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            KPIView(title: "Heute",  value: todayCount)
            KPIView(title: "Woche",  value: week)
            KPIView(title: "Monat",  value: month)
            KPIView(title: "Jahr",   value: year)
        }
    }
}

private struct KPIView: View {
    var title: String
    var value: Int

    var body: some View {
        VStack {
            Text(title).font(.headline)
            Text("\(value)").font(.largeTitle.bold())
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}
