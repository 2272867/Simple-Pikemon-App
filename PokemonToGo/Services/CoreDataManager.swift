import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonListCache")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getPokemonListItems() -> [PokemonListItemEntity] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<PokemonListItemEntity> = PokemonListItemEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            fatalError("Failed to fetch pokemon list items: \(error)")
        }
    }

    func savePokemonListItems(_ items: [PokemonListItem]) {
        let context = persistentContainer.viewContext
        context.perform {
            for item in items {
                let entity = PokemonListItemEntity(context: context)
                entity.id = item.id
                entity.name = item.name
                entity.url = item.url
                context.insert(entity)
            }
            do {
                try context.save()
            } catch {
                fatalError("Faild to save pokemon list item:\(error)")
            }
            
        }
    }
}
