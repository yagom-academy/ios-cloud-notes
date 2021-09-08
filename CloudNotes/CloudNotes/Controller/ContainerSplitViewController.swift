//
//  CloudNotes - ContainerSplitViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ContainerSplitViewController: UISplitViewController {
    private let columnStyle = UISplitViewController.Style.doubleColumn
    private let primaryViewController = MemoListViewController()
    private let secondaryViewController = MemoDetailViewController()
    
    required init?(coder: NSCoder) {
        super.init(style: columnStyle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewControllers()
        bringData()
        primaryViewController.cellSelectionDelegate = self
    }

}

//MARK:- Embed Inner ViewControllers
extension ContainerSplitViewController {
    private func embedViewControllers() {
        setViewController(primaryViewController, for: .primary)
    }
}

//MARK:- Bring the data what want to show
extension ContainerSplitViewController {
    private func bringData() {
        let dataModule = AssetJSONDataModule(assetName: "sample")
        let dataManager = DataManager(dataImportModule: dataModule)
        
        dataManager.obtainData { (result: Result<[Memo], Error>) in
            switch result {
            case .success(let memos):
                self.setDataToViewControllers(with: memos)
            case .failure(let error):
                break
            }
        }
    }
}

//MARK:- Set up the data what want to show
extension ContainerSplitViewController {
    private func setDataToViewControllers(with memoList: [Memo]) {
        primaryViewController.setUpList(with: memoList)
        show(.primary)
    }
}

//MARK:- Conforms to CellSellectionHandleable
extension ContainerSplitViewController: CellSellectionHandleable {
    func handOver(data memoItem: Memo) {
        secondaryViewController.configure(with: memoItem)
        if viewController(for: .secondary) == .none {
            setViewController(secondaryViewController, for: .secondary)
        }
        show(.secondary)
    }
}
