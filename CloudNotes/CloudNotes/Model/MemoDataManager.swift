import UIKit
import CoreData

class MemoDataManager {
    static let shared = MemoDataManager(modelName: "CloudNotes")
    var memos = [Memo]()
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func loadPersistentContainer() {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
    func saveViewContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occured while saving: \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchNotes() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Memo.lastModified, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            memos = try MemoDataManager.shared.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func fetch(
        entityName: String = "Memo",
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key: "lastModified", ascending: false)]
    ) -> [Memo]? {
    
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sortDescriptors
        guard let newData = try? viewContext.fetch(request) as? [Memo] else {
            return nil
        }
        return newData
    }
    
    func updateMemo(
        entityName: String = "Memo",
        id: UUID?,
        title: String?,
        body: String?,
        lastModified: Date = Date()
    ) {
        guard let id = id else {
            return
        }
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let memo = fetch(entityName: entityName, predicate: predicate)?.first else {
            return
        }
        memo.title = title
        memo.body = body
        memo.lastModified = lastModified
        saveViewContext()
    }
}

extension MemoDataManager {
    var newMemo: Memo {
        let newMemo = Memo(context: MemoDataManager.shared.viewContext)
        newMemo.id = UUID()
        newMemo.title = ""
        newMemo.body = ""
        newMemo.lastModified = Date()
        saveViewContext()

        return newMemo
    }
    
    var isEmpty: Bool {
        memos.count == 0
    }
}
