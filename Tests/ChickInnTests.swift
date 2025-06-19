import XCTest
@testable import ChickInn

final class ChickInnTests: XCTestCase {

    func testEggCreation() throws {
        let persistent = PersistenceController.shared
        let context = persistent.container.viewContext

        let chicken = Chicken(context: context)
        chicken.id = UUID()
        chicken.name = "Test"
        chicken.createdAt = .now
        chicken.photoData = Data()

        let egg = Egg(context: context)
        egg.id = UUID()
        egg.laidAt = .now
        egg.chicken = chicken

        try context.save()

        XCTAssertEqual(chicken.eggs.count, 1)
    }
}
