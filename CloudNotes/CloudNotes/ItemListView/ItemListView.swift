//
//  HeaderController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class ItemListView: UITableViewController {

    var itemListDataSource: ItemListViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        
        let memoList = loadMemoListForTest()
        itemListDataSource = ItemListViewDataSource(memoList: memoList!)
        self.tableView.dataSource = itemListDataSource
    }
    
    func loadMemoListForTest() -> [Memo]? {
        let assetName = "sampleData"
        
        guard let asset = NSDataAsset(name: assetName),
              let parsedAsset = try? JSONSerialization.jsonObject(
                with: asset.data,
                options: JSONSerialization.ReadingOptions()
              ) as? [[String: Any]] else {
            return nil
        }
        
        let memoList: [Memo] = parsedAsset.map { dictionary in
            return try! Parser.decode(from: dictionary, to: Memo.self).get()
        }
        
        return memoList
    }
}
