//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/07.
//

import Foundation
import UIKit

final class NoteListViewModel {
    let notes: [Note]
    
    init(_ notes: [Note] = []) {
        do {
            guard let dataAsset = NSDataAsset(name: "sample") else { throw DataError.notFoundAsset }
            guard let data = try? JSONDecoder().decode([Note].self, from: dataAsset.data) else { throw DataError.decodingFailed }
            self.notes = data
        } catch let error {
            print(error.localizedDescription)
            self.notes = []
        }
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
