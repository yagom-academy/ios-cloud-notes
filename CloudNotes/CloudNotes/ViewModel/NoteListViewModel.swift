//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/07.
//

import Foundation
import UIKit.NSDataAsset

final class NoteListViewModel {
    let notes: Observable<[NoteViewModel]> = Observable([])
    
    init(_ notes: Observable<[NoteViewModel]> = Observable([])) {
        do {
            guard let dataAsset = NSDataAsset(name: "sample") else { throw DataError.notFoundAsset }
            guard let data = try? JSONDecoder().decode([Note].self, from: dataAsset.data) else { throw DataError.decodingFailed }
            
            self.notes.value = data.compactMap({
                NoteViewModel($0)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension NoteListViewModel {
    func getNumberOfNotes() -> Int {
        return self.notes.value.count
    }
    
    func getNoteViewModel(for indexPath: IndexPath) -> NoteViewModel {
        return self.notes.value[indexPath.row]
    }
}
