//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/02.
//

import UIKit
import SwiftyDropbox

class MemoSplitViewController: UISplitViewController {
    
    let master = MemoListViewController()
    let detail = DetailMemoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DropboxManager.shared.authorize(viewController: self)
        setUpData()
        dismissKeyboardWhenTappedAround()
        self.delegate = self
        master.memoSplitViewController = self
        detail.memoListViewController = master
        self.viewControllers = [UINavigationController(rootViewController: master), UINavigationController(rootViewController: detail)]
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    private func setUpData() {
        CoreData.shared.getUpdatedFileList()
        CoreData.shared.getAllMemoListItems()
        updateJsonData(fileName: FileName.sample)
    }

    private func updateJsonData(fileName: String) {
        for fileNameInTheList in MemoCache.shared.updatedFileNameList {
            guard fileName != fileNameInTheList.name else {
                return
            }
        }
        CoreData.shared.createUpdatedFileListItem(fileName: fileName)

        let resultOfFetch = self.setUpData(fileName: fileName, model: [Memo].self)
        switch resultOfFetch {
        case .success(let data):
            CoreData.shared.convertMemoTypeToMemoListItemType(memoList: data) { bool in
                if bool {
                    self.master.tableView.reloadData()
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension MemoSplitViewController {
    func setUpData<T: Decodable>(fileName: String, model: T.Type) -> Result<T, DataError> {
        switch loadData(name: fileName) {
        case .success(let data):
            return decodeData(data: data, model: model)
        case .failure:
            return .failure(DataError.loadJSON)
        }
    }

    private func loadData(name: String) -> Result<NSDataAsset, DataError> {
        guard let jsonData: NSDataAsset = NSDataAsset(name: name)  else {
            return .failure(DataError.loadJSON)
        }
        return .success(jsonData)
    }

    private func decodeData<T: Decodable>(data: NSDataAsset, model: T.Type) -> Result<T, DataError> {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try jsonDecoder.decode(T.self, from: data.data)
            return .success(data)
        } catch {
            return .failure(DataError.decodeJSON)
        }
    }
}

extension UIViewController {
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
