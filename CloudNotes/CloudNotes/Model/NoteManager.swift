//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import Foundation
import UIKit

struct NoteManager {
    private var noteDatas: [Note] = []
    
    init() {
        guard let jsonData = NSDataAsset(name: "sample") else { return }
        guard let data = try? JSONDecoder().decode([Note].self, from: jsonData.data) else { return }
        noteDatas = data
    }
    
    var dataCount: Int {
        return noteDatas.count
    }
    
    func dataAtIndex(_ index: Int) -> Note {
        var data = noteDatas[index]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: TimeInterval(noteDatas[index].lastModify))
        data.date = dateFormatter.string(from: date)
        
        return data
    }
}
