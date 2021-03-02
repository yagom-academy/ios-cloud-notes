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
    
    func read() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.list = try context.fetch(Memo.fetchRequest())
        }
        catch {}
    }
    
    func create(title: String?, contents: String?) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
}
