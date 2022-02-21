import CoreData

final class MemoDataManager {
    static let shared = MemoDataManager(modelName: "CloudNotes")
    var memos = [Memo]()
    private let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext {
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
    
    private func saveViewContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occured while saving: \(error.localizedDescription)")
            }
        }
    }
    
    @discardableResult
    func fetchMemos(predicate: NSPredicate? = nil,
                    sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key: "lastModified", ascending: false)]
    ) -> [Memo] {
        let request = Memo.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sortDescriptors
        
        var memos: [Memo] = []
        do {
            memos = try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return memos
    }
    
    func updateMemo(id: UUID,
                    title: String,
                    body: String,
                    lastModified: Date)
    {
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        guard let memo = fetchMemos(predicate: predicate).first else {
            return
        }
        memo.title = title
        memo.body = body
        memo.lastModified = lastModified
        saveViewContext()
    }
    
    func deleteMemo(id: UUID) {
        let request = Memo.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        do {
            let memos = try viewContext.fetch(request)
            guard let memoToDelete = memos.first else {
                return
            }
            viewContext.delete(memoToDelete)
            saveViewContext()
        } catch {
            print(error.localizedDescription)
        }
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
