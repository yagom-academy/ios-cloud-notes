import UIKit

class SplitViewController: UISplitViewController {

    var memoList = [Memo]()
    let primaryVC = MemoListViewController(style: .insetGrouped)
    let secondaryVC = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChildView()
        setUpDisplay()
        setUpData()
        present(at: 0)
    }
    
    private func setUpChildView() {
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
    }
    
    private func setUpDisplay() {
        delegate = self
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
    }
    
    private func setUpData() {
        guard let decodedData = JSONParser().decode(fileName: "sample", decodingType: [Memo].self) else {
            return
        }
        memoList = decodedData
        setUpDataForMemoList()
    }
    
    private func setUpDataForMemoList() {
        var memoListInfo = [MemoListInfo]()
        memoList.forEach { memo in
            let title = memo.title.prefix(40).description
            let body = memo.body.prefix(70).description
            let lastModified = memo.lastModified.formattedDate
            memoListInfo.append(MemoListInfo(title: title, body: body, lastModified: lastModified))
        }
        primaryVC.setUpData(data: memoListInfo)
    }
    
    func present(at indexPath: Int) {
        let title = memoList[indexPath].title
        let body = memoList[indexPath].body
        secondaryVC.setUpData(with: MemoDetailInfo(title: title, body: body))
        show(.secondary)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
