//
//  CloudNotesDataSource.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/08.
//

import UIKit

final class CloudNotesDataSource: NSObject {
    
    // MARK: - Properties
    
    lazy private(set) var noteInformations: [NoteInformation]? = setupNoteInformations()
    
    // MARK: - Methods
    
    private func setupNoteInformations() -> [NoteInformation]? {
        guard let jsonData = NSDataAsset(name: "sample")?.data else {
            return nil
        }
        
        let result = JSONParser().decode(
          from: jsonData,
          decodingType: [NoteInformation].self
        )
        
        switch result {
        case .success(let noteInformations):
            return noteInformations
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Table View DataSource

extension CloudNotesDataSource: UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return noteInformations?.count ?? 0
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
        guard let information = noteInformations?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: information)
        return cell
    }
}
