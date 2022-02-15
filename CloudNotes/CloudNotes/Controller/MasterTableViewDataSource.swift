import UIKit
import CoreData

protocol MasterTableViewDataSourceProtocol: AnyObject {
    var memos: [Memo]? { get set }
    func fetchData() -> [Memo]?
}

final class MasterTableViewDataSource: NSObject, MasterTableViewDataSourceProtocol {
    lazy var memos: [Memo]? = fetchData()
    
    func fetchData() -> [Memo]? {
        let request = Memo.fetchRequest()
        return CoreDataManager.shared.fetch(request)
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
