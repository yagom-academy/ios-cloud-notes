//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/07.
//

import Foundation
import UIKit

final class NoteListViewModel {
    lazy var notes: [NoteData] = {
        do {
            return try self.decode()
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }()
    
    private func decode() throws -> [NoteData] {
        guard let dataAsset = NSDataAsset(name: "sample") else { throw DataError.notFoundAsset }
        guard let data = try? JSONDecoder().decode([NoteData].self, from: dataAsset.data) else { throw DataError.decodingFailed }
        
        return data
    }
}

extension NoteListViewModel {
    func getNumberOfNotes() -> Int {
        return self.notes.count
    }
    
    func getNoteViewModel(for indexPath: IndexPath) -> NoteViewModel {
        let note = self.notes[indexPath.row]
        return NoteViewModel(note: note)
    }
}
