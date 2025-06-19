import CoreData

@objc(Medication)
public class Medication: NSManagedObject { }

extension Medication {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var notes: String?
    @NSManaged public var chicken: Chicken
}

extension Medication : Identifiable { }
