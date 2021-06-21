//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/07.
//

import Foundation

final class NoteListViewModel: NoteManageable {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    var notes: Observable<[NoteData]> = Observable([])
    
    init(_ notes: Observable<[NoteData]> = Observable([])) {
        do {
            self.notes.value = try getAllNotes()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension NoteListViewModel {
    func getNumberOfNotes() -> Int {
        return self.notes.value.count
    }
    
    func getNoteData(at indexPath: IndexPath) -> NoteData {
        return notes.value[indexPath.row]
    }
    
    func getNote(at indexPath: IndexPath) -> String {
        let note = notes.value[indexPath.row]
        guard let title = note.title, let body = note.body else { return NoteLiteral.empty }
        return (title != NoteLiteral.empty ? title + NoteLiteral.LineBreak.String : title) + body
    }
}
