import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    weak var memoListViewController: MemoReloadable?
    weak var memoContentViewController: MemoReloadable?
    
    private init() { }
    
    func load() -> [Memo] {
        do {
            let context = AppDelegate.persistentContainer.viewContext
            return try context.fetch(Memo.fetchRequest()).reversed()
        } catch {
            print(error)
        }
        
        return []
    }
    
    func delete(data: Memo) {
        let context = AppDelegate.persistentContainer.viewContext
        context.delete(data)
        do {
            try context.save()
            memoListViewController?.reload()
            memoContentViewController?.reload()
        } catch {
            print(error)
        }
    }
    
    func update(data: Memo, title: String?, body: String?) {
        data.title = title
        data.body = body
        data.lastModified = Date().timeIntervalSince1970
        let context = AppDelegate.persistentContainer.viewContext
        do {
            try context.save()
            memoListViewController?.reload()
        } catch {
            print(error)
        }
    }
    
    func create() {
        let context = AppDelegate.persistentContainer.viewContext
        let memo = Memo(context: context)
        memo.lastModified = Date().timeIntervalSince1970
        do {
            try context.save()
            memoListViewController?.reload()
        } catch {
            print(error)
        }
    }
}
