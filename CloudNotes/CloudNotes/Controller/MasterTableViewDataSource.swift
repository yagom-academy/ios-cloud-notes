import UIKit

protocol MasterTableViewDataSourceProtocol: AnyObject {
    var memos: [Memo]? { get }
    func fetchData() -> [Memo]?
}

final class MasterTableViewDataSource: NSObject, MasterTableViewDataSourceProtocol {
    private(set) lazy var memos: [Memo]? = fetchData()
    
    func fetchData() -> [Memo]? {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        let memos = try? JSONDecoder().decode([Memo].self, from: data)
        
        return memos
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
