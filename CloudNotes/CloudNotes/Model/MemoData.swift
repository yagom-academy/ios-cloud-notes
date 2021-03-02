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
}
