import CoreData
import Foundation

class CoreDataStack {
    static var shared: CoreDataStack = CoreDataStack()
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
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
    
    func create(_ title: String, _ body: String?, _ date: Int) throws {
        let context = self.persistentContainer.viewContext
        let memo = Memo(context: context)
        print("Create")
        memo.title = title
        memo.body = body
        memo.date = Int64(date)
        try context.save()
    }
    func update(memo: Memo, _ title: String, _ body: String?, _ date: Int) throws {
        let context = self.persistentContainer.viewContext
        var isEdited = false
        if memo.title != title {
            memo.title = title
            isEdited = true
        }
        if memo.body != body {
            memo.body = body
            isEdited = true
        }
        if isEdited == false {
            return
        }
        memo.date = Int64(date)
        try context.save()
    }
    
    func delete(memo: Memo) throws {
        let context = self.persistentContainer.viewContext
        context.delete(memo)
        try context.save()
    }
}
