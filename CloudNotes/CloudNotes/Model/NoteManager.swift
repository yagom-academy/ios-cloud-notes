//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import Foundation
import UIKit

struct NoteManager {
    private var noteDatas: [Note]?
    
    init() {
        guard let jsonData = NSDataAsset(name: "sample") else { return }
        guard let data = try? JSONDecoder().decode([Note].self, from: jsonData.data) else { return }
        noteDatas = data
    }
    
    var dataCount: Int {
        return noteDatas?.count ?? 0
    }
    
    func dataAtIndex(_ index: Int) -> Note {
        var data = noteDatas?[index] ?? Note(title: "", description: "", lastModify: 0, date: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy.MM.dd")
        let date = Date(timeIntervalSince1970: TimeInterval(data.lastModify))
        data.date = dateFormatter.string(from: date)
        
        return data
    }
}
