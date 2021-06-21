//
//  NoteTextViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/12.
//

final class NoteTextViewModel {
    let noteData: Observable<NoteData>
    
    init(_ note: NoteData) {
        self.noteData = Observable(note)
    }
}

extension NoteTextViewModel {
    func getTextViewData() -> String {
        guard let title = noteData.value.title, let body = noteData.value.body else { return NoteLiteral.empty }
        return (title != NoteLiteral.empty ? title + NoteLiteral.LineBreak.String : title) + body
    }
}
