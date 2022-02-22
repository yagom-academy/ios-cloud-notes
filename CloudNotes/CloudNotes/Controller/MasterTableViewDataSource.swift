import UIKit
import CoreData

protocol MasterTableViewDataSourceProtocol: AnyObject {
    //var memos: [MemoEntity]? { get set }
    func fetchMemos()
    func saveMemo(_ memo: MemoEntity)
    func updateMemo(_ memo: MemoEntity)
    func deleteMemo(with memoId: UUID?)
    func retrieveMemos() -> [MemoEntity]?
    func removeMemo(at index: Int) -> MemoEntity?
    func insertMemo(_ memo: MemoEntity, at index: Int)
}

final class MasterTableViewDataSource: NSObject, MasterTableViewDataSourceProtocol {
//    let memoCoreDataManager: StorageProtocol?  // 프로토콜/제네릭 관련 오류 발생
    private var memoCoreDataManager: MemoCoreDataManager? = MemoCoreDataManager()
     var memos: [MemoEntity]?
 
    override init() {
        super.init()
        fetchMemos()
    }
  
    func fetchMemos() {
        let request = Memo.fetchRequest()
        
        memos = memoCoreDataManager?.fetch(request)
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
