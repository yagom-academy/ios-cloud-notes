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
