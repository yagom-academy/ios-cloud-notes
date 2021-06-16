//
//  CoreDataStack.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/16.
//

import UIKit
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let converter: ConvertDate = ConvertDate.shared
    
    func fetch() -> [MemoData] {
        let fetchRequest = NSFetchRequest<MemoData>(entityName: "MemoData")
        let sort = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let result = try! context.fetch(fetchRequest)
        
        return result
    }
    
    func createMemoData() {
        let newMemoData = MemoData(context: context)
        newMemoData.title = ""
        newMemoData.body = ""
        newMemoData.lastModified = converter.convertDouble()
        do {
            try context.save()
        } catch {
            MemoError.failCreate
        }
    }
    
    func deleteMemoData(data: MemoData) {
        context.delete(data)
        
        do {
            try context.save()
        } catch {
            MemoError.failDelete
        }
    }
    
    func updateMemoData(titleText: String, bodyText: String, data: MemoData) {
        data.title = titleText
        data.body = bodyText
        data.lastModified = converter.convertDouble()
        
        do {
            try context.save()
        } catch {
            MemoError.failUpdate
        }
    }
    
}
