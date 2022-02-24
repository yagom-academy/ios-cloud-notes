import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    weak var memoListViewController: MemoReloadable?
    weak var memoContentViewController: MemoReloadable?
    
    private let persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() { }

    func saveContextChange () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func load(errorHandler: (Error) -> Void) -> [Memo] {
        do {
            return try context.fetch(Memo.fetchRequest()).reversed()
        } catch {
            errorHandler(error)
        }
        
        return []
    }
    
    func delete(data: Memo, errorHandler: (Error) -> Void) {
        context.delete(data)
        do {
            try context.save()
            memoListViewController?.reload()
            memoContentViewController?.reload()
        } catch {
            errorHandler(error)
        }
    }
    
    func update(data: Memo, title: String?, body: String?, errorHandler: (Error) -> Void) {
        data.title = title
        data.body = body
        data.lastModified = Date().timeIntervalSince1970
        do {
            try context.save()
            memoListViewController?.reload()
        } catch {
            errorHandler(error)
        }
    }
    
    func create(errorHandler: (Error) -> Void) {
        let memo = Memo(context: context)
        memo.lastModified = Date().timeIntervalSince1970
        do {
            try context.save()
            memoListViewController?.reload()
        } catch {
            errorHandler(error)
        }
    }
}
