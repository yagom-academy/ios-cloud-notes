//
//  PrimaryTableViewDataSource.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewDataSource: NSObject {
    typealias SelectedMemoAction = (Memo, IndexPath, Bool) -> Void
    
    private var selectedMemoAction: SelectedMemoAction?
    private var memos: [Memo] = []
    
    init(showDetailAction: @escaping SelectedMemoAction) {
        super.init()
        self.selectedMemoAction = showDetailAction
        readAllMemos()
    }
    
    private func readAllMemos() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: "sample") else {
            print("에러처리 필요 - 파일 바인딩 실패")
            return
        }

        do {
            memos = try decoder.decode([Memo].self, from: dataAsset.data)

            guard let baseMemo = memos.first else {
                print("에러처리 필요 - 메모데이터 없음")
                return
            }
            selectedMemoAction?(baseMemo, IndexPath(row: 0, section: 0), false)
        } catch {
            print("에러처리 필요 - 디코딩 실패")
        }
    }
}

// MARK: - TableView DataSource
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
        cell.configure(by: memo)

        return cell
    }
}

// MARK: - TableView Delegate
extension PrimaryTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row]
        selectedMemoAction?(selectedMemo, indexPath, true)
    }
}

extension PrimaryTableViewDataSource {
    func update( _ memo: Memo?, _ indexPath: IndexPath?, completion: @escaping () -> Void) {
        guard let index = indexPath?.row,
              let item = memo else {
            print("에러처리 필요 - 데이터 없음")
            return
        }
        memos[index] = item
        completion()
    }
}
