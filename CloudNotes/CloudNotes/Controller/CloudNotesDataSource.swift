//
//  CloudNotesDataSource.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/08.
//

import UIKit

final class CloudNotesDataSource: NSObject {
    
    // MARK: - Properties
    
    let persistantManager: PersistantManager?
    
    init(persistantManager: PersistantManager?) {
        self.persistantManager = persistantManager
    }
}

// MARK: - Table View DataSource

extension CloudNotesDataSource: UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return persistantManager?.notes.count ?? 0
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
        guard let information = persistantManager?.notes[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: information)
        return cell
    }
}
