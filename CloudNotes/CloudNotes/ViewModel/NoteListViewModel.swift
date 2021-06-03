//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import Foundation
import UIKit

struct NoteListViewModel {
    private var noteDatas: [NoteData] = []
    
    init() {
        guard let jsonData = NSDataAsset(name: "sample") else { return }
        guard let data = try? JSONDecoder().decode([NoteData].self, from: jsonData.data) else { return }
        noteDatas = data
    }
    
    var dataCount: Int {
        return noteDatas.count
    }
    
    func dataAtIndex(_ index: Int) -> NoteData {
        var data = noteDatas[index]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: TimeInterval(noteDatas[index].lastModify))
        data.date = dateFormatter.string(from: date)
        
        return data
    }
}
