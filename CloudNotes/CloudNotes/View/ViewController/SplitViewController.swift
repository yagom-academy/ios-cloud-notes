//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/02.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    
    let master = MemoListViewController()
    let detail = DetailMemoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        self.delegate = self
        master.horizontalSizeClass = UITraitCollection.current.horizontalSizeClass
        master.memoSplitViewController = self
        self.viewControllers = [UINavigationController(rootViewController: master), UINavigationController(rootViewController: detail)]
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.horizontalSizeClass ==  .regular {
            master.horizontalSizeClass = .compact
        } else {
            master.horizontalSizeClass = .regular
        }
    }
    
    private func setUpData() {
        let resultOfFetch = setUpData(fileName: "sample", model: [Memo].self)
        switch resultOfFetch {
        case .success(let data):
            Cache.shared.decodedJsonData = data
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

extension UIViewController {
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

    private func decodeData<T:Decodable>(data: NSDataAsset, model: T.Type) -> Result<T, DataError> {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try jsonDecoder.decode(T.self, from: data.data)
            return .success(data)
        } catch {
            return .failure(DataError.decodeJSON)
        }
    }
}
