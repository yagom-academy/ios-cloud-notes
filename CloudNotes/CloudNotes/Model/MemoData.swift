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
    
    func create(text: String?) {
        guard let text = text else { return }
        let newTitle = spiltText(text: text).title
        let newContents = spiltText(text: text).contents
        let newMemo = Memo(context: context)
        newMemo.title = newTitle
        newMemo.contents = newContents
        newMemo.lastModifiedDate = Date()
        
        do {
            try context.save()
            read()
        }
        catch {}
    }
    
    func update(memo: Memo?, text: String?) {
        guard let memo = memo else { return }
        guard let text = text else { return }
        let updatedTitle = spiltText(text: text).title
        let updatedContents = spiltText(text: text).contents
        
        memo.title = updatedTitle
        memo.contents = updatedContents
        memo.lastModifiedDate = Date()
        
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
    
    private func spiltText(text: String) -> (title: String?, contents: String?) {
        let dividedMemo = text.split(separator: "\n", maxSplits: 1).map(String.init)
        let title = dividedMemo.first
        let contents = dividedMemo.last
        return (title, contents)
    }
}
