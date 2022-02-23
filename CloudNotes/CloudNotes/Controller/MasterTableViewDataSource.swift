import UIKit
import CoreData

protocol MemosManageable: AnyObject {
    func retrieveMemos() -> [MemoEntity]?
    func removeMemo(at index: Int) -> MemoEntity?
    func insertMemo(_ memo: MemoEntity, at index: Int)
}

protocol CoreDataManageable: AnyObject {
    func fetchMemos()
    func saveMemo(_ memo: MemoEntity)
    func updateMemo(_ memo: MemoEntity)
    func deleteMemo(with memoId: UUID?)
}

typealias MasterTableViewDataSourceProtocol = MemosManageable & CoreDataManageable

final class MasterTableViewDataSource: NSObject, MasterTableViewDataSourceProtocol {
    private var memoCoreDataManager: MemoCoreDataManager? = MemoCoreDataManager()
    private var memos: [MemoEntity]?
 
    override init() {
        super.init()
        fetchMemos()
    }
}

// MARK: - MemosManageable
extension MasterTableViewDataSource {
    func retrieveMemos() -> [MemoEntity]? {
        return memos
    }
    
    func removeMemo(at index: Int) -> MemoEntity? {
        guard let memoToRemove = memos?.remove(at: index) else {
            return nil
        }
        
        return memoToRemove
    }
    
    func insertMemo(_ memo: MemoEntity, at index: Int) {
        memos?.insert(memo, at: index)
    }
}

// MARK: - CoreDataManageable
extension MasterTableViewDataSource {
    func fetchMemos() {
        let request = Memo.fetchRequest()
        
        memos = memoCoreDataManager?.fetchMemo(request)
    }
    
    func saveMemo(_ memo: MemoEntity) {
        memoCoreDataManager?.saveContext(memo: memo)
    }
    
    func updateMemo(_ memo: MemoEntity) {
        memoCoreDataManager?.updateMemo(memo)
    }
    
    func deleteMemo(with memoId: UUID?) {
        memoCoreDataManager?.deleteMemo(memoId: memoId)
    }
}

// MARK: - Table view data source
extension MasterTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MasterTableViewCell.self, for: indexPath)
        
        guard let memos = memos else {
            return UITableViewCell()
        }
        
        cell.configureUI()
        cell.applyData(memos[indexPath.row])
        
        return cell
    }      
}
