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
        
        itemListViewCell.titleLabel.backgroundColor = .cyan
        itemListViewCell.dateLabel.backgroundColor = .systemGreen
        itemListViewCell.descriptionLabel.backgroundColor = .gray
        
        itemListViewCell.configure(with: memoList[indexPath.row])
        
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
            let decodedDictionary = Parser.decode(from: dictionary, to: Memo.self)
            
            guard let memo = try? decodedDictionary.get() else {
                let corrupted = "Corrupted"
                let date = Date(timeIntervalSince1970: .zero)
                
                return Memo(
                    title: corrupted,
                    description: corrupted,
                    lastUpdatedTime: date
                )
            }
            
            return memo
        }
        
        return memoList
    }
}
