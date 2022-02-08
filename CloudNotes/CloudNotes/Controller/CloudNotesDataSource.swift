//
//  CloudNotesDataSource.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/08.
//

import UIKit

class CloudNotesDataSource: NSObject {
    lazy var noteInformations: [NoteInformation]? = setupNoteInformations()
    
    func setupNoteInformations() -> [NoteInformation]? {
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
        guard let informations = noteInformations else {
            return UITableViewCell()
        }
        cell.configure(with: informations[indexPath.row])
        return cell
    }
}
