//
//  NoteListDataSource.swift
//  CloudNotes
//
//  Created by 서녕 on 2022/02/18.
//

import UIKit

final class NoteListDataSource: NSObject {
    let persistentManager: PersistentManager?
    
    init(persistentManager: PersistentManager?) {
        self.persistentManager = persistentManager
    }
}

extension NoteListDataSource: UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return persistentManager?.notes.count ?? 0
    }
    
    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: NoteListCell.identifier,
          for: indexPath
        ) as? NoteListCell else {
            return UITableViewCell()
        }
        guard let information = persistentManager?.notes[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: information)
        return cell
    }
}
