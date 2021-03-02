//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/27.
//
//

import UIKit
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var date: Int64
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}

extension Memo : Identifiable {

}

extension Memo {
    class func create(_ title: String, _ body: String?, _ date: Int) throws {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        let memo = self.init(context: context)
        memo.title = title
        memo.body = body
        memo.date = Int64(date)
        try context.save()
    }
    
    class func read() throws -> [Memo]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return nil
        }
        if let memos = try context.fetch(self.fetchRequest()) as? [Memo] {
            return memos
        }
        return nil
    }
    
    class func update(memo: Memo, _ title: String, _ body: String?, _ date: Int) throws {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        var isEdited = false
        if memo.title != title {
            memo.title = title
            isEdited = true
        }
        if memo.body != body {
            memo.body = body
            isEdited = true
        }
        if isEdited == false {
            return
        }
        memo.date = Int64(date)
        try context.save()
    }
    
    class func delete(memo: Memo) throws {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        context.delete(memo)
        try context.save()
    }
}
