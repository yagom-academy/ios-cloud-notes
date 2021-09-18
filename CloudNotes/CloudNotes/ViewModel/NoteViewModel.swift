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

        var memoViewModels = [MemoCellViewModel]()
        notes.forEach { note in
            memoViewModels.append(createCellModel(memo: note))
        }
        memoCellViewModels = memoViewModels
    }

    private func createCellModel(memo: Note) -> MemoCellViewModel {
        guard let title = memo.title,
              let body = memo.body,
              let uuid = memo.uuid else {
            return MemoCellViewModel(title: "제목 없음", body: "내용 없음", lastModified: "", uuid: UUID())
        }
        let lastModified = memo.lastModified
        let formattedDate = lastModified.changeDateFormat()
        return MemoCellViewModel(title: title, body: body, lastModified: formattedDate, uuid: uuid)
    }

    func getCellViewModel(at indexPath: IndexPath) -> MemoCellViewModel {
        return memoCellViewModels[indexPath.row]
    }

    func deleteNote(uuid: UUID) -> Bool {
        let success: Bool = true

        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(Note.uuid), uuid as NSUUID)

        do {
            let notes = try PersistanceManager.shared.context.fetch(request)
            notes.forEach { note in
                PersistanceManager.shared.context.delete(note)
            }
            return success
        } catch {
            print(error.localizedDescription)
        }
        return !success
    }

    func deleteAllNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let result = PersistanceManager.shared.deleteAll(request: request)

        if result {
            memoCellViewModels = []
        }
    }
}
