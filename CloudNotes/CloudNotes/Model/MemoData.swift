//
//  MemoData.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/03/03.
//

import UIKit
import CoreData

final class MemoData {
    static let shared = MemoData()
    private init() {}
    
    var list: [Memo] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func read() {
        do {
            self.list = try context.fetch(Memo.fetchRequest())
        }
        catch {}
    }
    
    func create(title: String?, contents: String?) {
        let newMemo = Memo(context: context)
        newMemo.title = title
        newMemo.contents = contents
        newMemo.lastModifiedDate = Date()
        
        do {
            try context.save()
            read()
        }
        catch {}
    }
    
    func delete(memo: Memo?) {
        guard let memo = memo else { return }
        context.delete(memo)
        
        do {
            try context.save()
            read()
        }
        catch {}
    }
}
