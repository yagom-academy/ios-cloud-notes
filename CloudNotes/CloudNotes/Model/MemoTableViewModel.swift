//
//  MemoTableViewModel.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/07.
//

import UIKit

struct MemoTableViewModel {
    weak var delegate: MemoTableViewModelDelegate?
    
    func requestData() {
        let decoder = JSONDecoder()
        let memoDataIdentifier = "sample"
        
        guard let dataAsset = NSDataAsset(name: memoDataIdentifier),
              let memos = try? decoder.decode([Memo].self, from: dataAsset.data) else {
            return
        }
        delegate?.didUpdateData(data: memos)
    }
}

protocol MemoTableViewModelDelegate: AnyObject {
    func didUpdateData(data: [Savable])
}
