//
//  PrimaryTableViewDataSource.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewDataSource: NSObject {
    private var memos: [Memo] = []
    
    override init() {
        super.init()
        readAllMemos()
    }
    
    private func readAllMemos() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let sampleName = "sample"
        guard let dataAsset = NSDataAsset(name: sampleName) else {
            print("에러처리 필요 - 파일 바인딩 실패")
            return
        }
 
        do {
            let decoded = try decoder.decode([Memo].self, from: dataAsset.data)
            memos = decoded
        } catch {
            print("에러처리 필요 - 디코딩 실패")
        }
    }
}

extension PrimaryTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? PrimaryTableViewCell else {
            return UITableViewCell()
        }
        
        let memo = memos[indexPath.row]
        cell.configure(title: memo.title, detail: memo.body, date: memo.lastModified)

        return cell
    }
    
}

