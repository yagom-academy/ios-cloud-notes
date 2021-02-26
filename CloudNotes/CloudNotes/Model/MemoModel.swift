//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/15.
//

import UIKit
import CoreData

class MemoModel {
    static let shared = MemoModel()
    private init() {}
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var list: [Memo] = []
    
    func fetch() {
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sort = NSSortDescriptor(key: "registerDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            self.list = try context?.fetch(fetchRequest) as! [Memo]
        } catch {
            print(error.localizedDescription)
        }
    }
}
