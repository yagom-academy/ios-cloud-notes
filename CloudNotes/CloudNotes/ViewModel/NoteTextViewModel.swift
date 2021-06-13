//
//  NoteTextViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/12.
//

final class NoteTextViewModel {
    let note: Observable<NoteViewModel>
    
    init(_ note: Observable<NoteViewModel>) {
        self.note = note
    }
}

extension NoteTextViewModel {
    func getTextViewData() -> String {
        return note.value.title + "\n\n" + note.value.body
    }
}
