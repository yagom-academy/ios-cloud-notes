import CoreData

protocol MemoDataManagable {
    var isEmpty: Bool { get }
    var numberOfMemos: Int { get }
    func getCurrentMemo(for indexPath: IndexPath) -> Memo
    func insertMemo(at index: Int)
    func updateMemo(id: UUID, title: String, body: String, lastModified: Date)
    func deleteMemo(id: UUID)
}

final class MemoDataManager {
    private let persistentContainer: NSPersistentContainer
    private lazy var viewContext = persistentContainer.viewContext
    
    private var memos = [Memo]()
    private var newMemo: Memo {
        let newMemo = Memo(context: viewContext)
        newMemo.id = UUID()
        newMemo.title = ""
        newMemo.body = ""
        newMemo.lastModified = Date()
        saveViewContext()
        return newMemo
    }
    
    init(modelName: String = "CloudNotes") {
        persistentContainer = NSPersistentContainer(name: modelName)
        loadPersistentContainer()
        setMemos()
    }
    
    func loadPersistentContainer() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
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
    
    private func setMemos() {
        memos = fetchMemos()
    }
    
    private func fetchMemos(predicate: NSPredicate? = nil,
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
}

// MARK: - MemoDataManagable Protocol

extension MemoDataManager: MemoDataManagable {
    var isEmpty: Bool {
        memos.count == 0
    }
    
    var numberOfMemos: Int {
        memos.count
    }
    
    func getCurrentMemo(for indexPath: IndexPath) -> Memo {
        memos[indexPath.row]
    }
    
    func insertMemo(at index: Int) {
        memos.insert(newMemo, at: index)
    }
    
    func updateMemo(id: UUID,
                    title: String,
                    body: String,
                    lastModified: Date) {
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
            let memoToDeleteInArray = self.memos.filter { $0.id == id }
            self.memos = self.memos.filter { memoToDeleteInArray.contains($0) == false }
            saveViewContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}
