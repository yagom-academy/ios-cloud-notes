import CoreData

protocol MemoDataManagerListDelegate: AnyObject {
    func setupRowSelection()
    func addNewMemo()
    func deleteMemo2(at indexPath: IndexPath)
    func selectNextMemo(at indexPath: IndexPath)
    var selectedCellIndex: IndexPath? { get }
}

protocol MemoDataManagerDetailDelegate: AnyObject {
    func showTextView(with memo: Memo)
    func showEmptyTextView()
    func showIneditableTextView()
}

final class MemoDataManager {
    weak var listDelegate: MemoDataManagerListDelegate?
    weak var detailDelegate: MemoDataManagerDetailDelegate?
    
    var memos = [Memo]()
    private let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String = "CloudNotes") {
        persistentContainer = NSPersistentContainer(name: modelName)
        loadPersistentContainer()
        setMemosArray()
    }
    
    func loadPersistentContainer() {
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setMemosArray() {
        memos = fetchMemos()
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
            let memoToDeleteInArray = self.memos.filter { $0.id == id }
            self.memos = self.memos.filter { memoToDeleteInArray.contains($0) == false }
            saveViewContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MemoDataManager {
    var newMemo: Memo {
        let newMemo = Memo(context: viewContext)
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

// MARK: - MemoDataManagerListDelegate

extension MemoDataManager {
    func selectFirstMemo() {
        if memos.isEmpty == false {
            listDelegate?.setupRowSelection()
            detailDelegate?.showTextView(with: memos[0])
        }
    }
    
    func addNewMemo() {
        memos.insert(newMemo, at: 0)
        listDelegate?.addNewMemo()
        detailDelegate?.showEmptyTextView()
    }
    
    func deleteSelectedMemo(at indexPath: IndexPath? = nil) {
        let selectecIndexPath: IndexPath?
        if indexPath != nil {
            selectecIndexPath = indexPath
        } else {
            selectecIndexPath = listDelegate?.selectedCellIndex
        }
        
        guard let selectecIndexPath = selectecIndexPath else {
            return
        }
        let deletedMemo = memos[selectecIndexPath.row]
        deleteMemo(id: deletedMemo.id)
        listDelegate?.deleteMemo2(at: selectecIndexPath)
        
        if selectecIndexPath.row < memos.count {
            let memo = memos[selectecIndexPath.row]
            detailDelegate?.showTextView(with: memo)
            listDelegate?.selectNextMemo(at: selectecIndexPath)
        } else {
            detailDelegate?.showIneditableTextView()
        }
    }
}
