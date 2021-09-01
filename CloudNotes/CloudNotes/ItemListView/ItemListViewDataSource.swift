//
//  Da.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class ItemListViewDataSource: NSObject, UITableViewDataSource {
    lazy var memoList: [Memo] = loadMemoListForTest() ?? []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemListViewCell = tableView.dequeueReusableCell(withIdentifier: ItemListViewCell.identifier) as? ItemListViewCell else {
            return UITableViewCell()
        }
    
        return itemListViewCell
    }
    
    
    private func loadMemoListForTest() -> [Memo]? {
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
