//
//  NoteListDataSource.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/16.
//

import UIKit

class NoteListDataSource: NSObject, UITableViewDataSource {
    weak var noteManager: NoteManager?
    
    init(noteManager: NoteManager) {
        self.noteManager = noteManager
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteManager?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: NotesTable.cellIdentifier) as? NoteCell,
              let note = noteManager?.fetchNote(at: indexPath.row),
              let count = noteManager?.count,
              indexPath.row < count else { return UITableViewCell() }

        cell.initCell(with: note)

        return cell
    }
}
