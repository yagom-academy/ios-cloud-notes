//
//  NoteViewModel.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/15.
//

import UIKit
import CoreData

class NoteViewModel {

    // MARK: - Properties
    var reloadTableView: (() -> Void)?
    var memoCellViewModels = [MemoCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    // MARK: - Methods
    func fetchNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let notes = PersistanceManager.shared.fetch(request: request)
        notes.forEach { note in
            memoCellViewModels.append(createCellModel(memo: note))
        }
    }

    private func createCellModel(memo: Note) -> MemoCellViewModel {
        guard let title = memo.title,
              let body = memo.body else {
            return MemoCellViewModel(title: "제목 없음", body: "내용 없음", lastModified: "")
        }
        let lastModified = memo.lastModified
        let formattedDate = lastModified.changeDateFormat()
        return MemoCellViewModel(title: title, body: body, lastModified: formattedDate)
    }

    func getCellViewModel(at indexPath: IndexPath) -> MemoCellViewModel {
        return memoCellViewModels[indexPath.row]
    }
}
