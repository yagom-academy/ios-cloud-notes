import UIKit

final class MasterTableViewDataSource: NSObject {
    private(set) lazy var memos = fetchData()
    
    private func fetchData() -> [Memo]? {
        guard let file = Bundle.main.path(forResource: "sample", ofType: "json") else {
            return nil
        }
        
        guard let data = try? String(contentsOfFile: file).data(using: .utf8) else {
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
