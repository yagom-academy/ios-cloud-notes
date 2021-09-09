//
//  MemoTableViewModel.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/07.
//

import UIKit

class MemoViewModel {

    // MARK: - Properties
    var reloadTableView: (() -> Void)?
    var memoCellViewModels = [MemoCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    // MARK: - Methods
    func decodeData() {
        let decoder = JSONDecoder()
        let memoDataIdentifier = "sample"

        guard let dataAsset = NSDataAsset(name: memoDataIdentifier),
              let memoDatas = try? decoder.decode([Memo].self, from: dataAsset.data) else {
            return
        }

        memoDatas.forEach { memo in
            memoCellViewModels.append(createCellModel(memo: memo))
        }
    }

    private func createCellModel(memo: Memo) -> MemoCellViewModel {
        guard let title = memo.title,
              let body = memo.body,
              let lastModified = memo.lastModified else {
            return MemoCellViewModel(title: "제목 없음", body: "내용 없음", lastModified: "")
        }
        let formattedDate = changeDateFormat(lastModified)
        return MemoCellViewModel(title: title, body: body, lastModified: formattedDate)
    }

    func getCellViewModel(at indexPath: IndexPath) -> MemoCellViewModel {
        return memoCellViewModels[indexPath.row]
    }

    private func changeDateFormat(_ time: Int) -> String {
        let dateFormatter = DateFormatter()
        let usersLocale = Locale.current
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = usersLocale
        
        let date = Date(timeIntervalSince1970: Double(time))
        
        return dateFormatter.string(from: date)
    }
}
