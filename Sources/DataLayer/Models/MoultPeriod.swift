import CoreData

@objc(MoultPeriod)
public class MoultPeriod: NSManagedObject { }

extension MoultPeriod {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoultPeriod> {
        NSFetchRequest<MoultPeriod>(entityName: "MoultPeriod")
    }

    @NSManaged public var id: UUID
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var chicken: Chicken
}

extension MoultPeriod : Identifiable { }
