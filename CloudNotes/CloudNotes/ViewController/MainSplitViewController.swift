import UIKit

class MainSplitViewController: UISplitViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = NSDataAsset(name: "sample"),
              let memos = try? JSONDecoder().decode([Memo].self, from: data.data) else {
                  return
              }
        setViewController(ListViewController(memos: memos), for: .primary)
        setViewController(MemoViewController(), for: .secondary)
        self.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
