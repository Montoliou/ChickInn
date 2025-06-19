import CoreData
import UIKit

@objc(Chicken)
public class Chicken: NSManagedObject { }

extension Chicken {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chicken> {
        NSFetchRequest<Chicken>(entityName: "Chicken")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var photoData: Data
    @NSManaged public var createdAt: Date
    @NSManaged public var notes: String?
    @NSManaged public var eggs: Set<Egg>
    @NSManaged public var moultings: Set<MoultPeriod>
    @NSManaged public var medications: Set<Medication>
}

extension Chicken : Identifiable { }
