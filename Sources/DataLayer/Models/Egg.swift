import CoreData

@objc(Egg)
public class Egg: NSManagedObject { }

extension Egg {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Egg> {
        NSFetchRequest<Egg>(entityName: "Egg")
    }

    @NSManaged public var id: UUID
    @NSManaged public var laidAt: Date
    @NSManaged public var photoData: Data?
    @NSManaged public var notes: String?
    @NSManaged public var chicken: Chicken
}

extension Egg : Identifiable { }
