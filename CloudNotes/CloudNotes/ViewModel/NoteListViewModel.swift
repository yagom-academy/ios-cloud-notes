//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/07.
//

import Foundation
import UIKit.NSDataAsset

final class NoteListViewModel {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    let notes: Observable<[Note]> = Observable([])
    
    init(_ notes: Observable<[Note]> = Observable([])) {
        do {
            guard let dataAsset = NSDataAsset(name: "sample") else { throw DataError.notFoundAsset }
            guard let data = try? JSONDecoder().decode([Note].self, from: dataAsset.data) else { throw DataError.decodingFailed }
            
            self.notes.value = data
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension NoteListViewModel {
    func getNumberOfNotes() -> Int {
        return self.notes.value.count
    }
    
    func getNoteViewModel(for indexPath: IndexPath) -> Note {
        var note = notes.value[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(note.lastModified))
        note.formattedLastModified = NoteListViewModel.dateFormatter.string(from: date)
        
        return note
    }
}
