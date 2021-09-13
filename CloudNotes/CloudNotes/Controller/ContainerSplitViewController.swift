//
//  CloudNotes - ContainerSplitViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ContainerSplitViewController: UISplitViewController {
    //MARK: Properties
    private let columnStyle = UISplitViewController.Style.doubleColumn
    private let primaryViewController = MemoListViewController()
    private let secondaryViewController = MemoDetailViewController()
    
    //MARK: Initializer
    required init?(coder: NSCoder) {
        super.init(style: columnStyle)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewControllers()
        bringData()
        primaryViewController.cellSelectionDelegate = self
        secondaryViewController.memoModifyingDelegate = self
    }
}

//MARK:- Embed Inner ViewControllers
extension ContainerSplitViewController {
    private func embedViewControllers() {
        setViewController(primaryViewController, for: .primary)
        show(.primary)
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
                self.presentAlert(about: error)
            }
        }
    }
    
    private func presentAlert(about error: Error) {
        let alertController = UIAlertController(title: "오류 발생", message: error.localizedDescription, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmButton)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Set up the data what want to show
extension ContainerSplitViewController {
    private func setDataToViewControllers(with memoList: [Memo]) {
        primaryViewController.setUpList(with: memoList)
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

//MARK:- Conforms to MemoChangeHandleable
extension ContainerSplitViewController: MemoChangeHandleable {
    func processModified(data memoItem: Memo) {
        primaryViewController.reflectChange(with: memoItem)
    }
}
