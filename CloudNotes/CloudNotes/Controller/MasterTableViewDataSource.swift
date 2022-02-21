import UIKit
import CoreData

protocol MasterTableViewDataSourceProtocol: AnyObject {
    var memos: [Memo]? { get set }
    func fetchMemos()
    func saveMemo(_ memo: TemporaryMemo)
    func updateMemo(_ memo: Memo)
    func deleteMemo(with memoId: UUID?)
}

final class MasterTableViewDataSource: NSObject, MasterTableViewDataSourceProtocol {
    let coreDataManager = CoreDataManager()
    var memos: [Memo]?
    
    override init() {
        super.init()
        self.fetchMemos()
    }
    
    func fetchMemos() {
        let request = Memo.fetchRequest()
        
        memos = coreDataManager.fetch(request)
    }
    
    func saveMemo(_ memo: TemporaryMemo) {
        coreDataManager.saveContext(memo: memo)
    }
    
    func updateMemo(_ memo: Memo) {
        coreDataManager.updateMemo(memo)
    }
    
    func deleteMemo(with memoId: UUID?) {
        coreDataManager.deleteMemo(memoId: memoId)
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
