//
//  PrimaryTableViewDataSource.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewDataSource: NSObject {
    
    typealias SelectedMemoAction = (Memo, Bool) -> Void
    
    private var memos: [Memo] = []
    private var selectedMemoAction: SelectedMemoAction?
    
    private var dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
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
            let decoded = try decoder.decode([Memo].self, from: dataAsset.data)
            memos = decoded
            
            guard let baseMemo = memos.first else {
                print("에러처리 필요 - 메모데이터 없음")
                return
            }
            selectedMemoAction?(baseMemo, true)
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
        
        let date: String = dateformatter.string(from: Date(timeIntervalSince1970: memo.lastModified))
        let text = memo.body ?? ""
        let summary: String = String(text[text.startIndex...(text.firstIndex(of: ".") ?? text.endIndex)])
        
        cell.configure(title: memo.title, summary: summary, date: date)

        return cell
    }
}

extension PrimaryTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row]
        selectedMemoAction?(selectedMemo, false)
    }
}
