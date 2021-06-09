//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import CoreData
import UIKit

final class NoteManager {
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [Note] {
        var noteList: [Note]?
        let fetchRequest: NSFetchRequest<NoteModel> = NoteModel.fetchRequest()
        let lastModifyDesc = NSSortDescriptor(key: "lastModify", ascending: false)
        fetchRequest.sortDescriptors = [lastModifyDesc]
        
        do {
            let result = try self.context.fetch(fetchRequest)
            
            for record in result {
                let data = Note(title: record.title, body: record.body, lastModify: record.lastModify)
                noteList?.append(data)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return noteList ?? []
    }
    
    func insert(_ data: Note) {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: "CloudNotes", into: self.context) as? NoteModel else { return }
        object.title = data.title
        object.body = data.body
        object.lastModify = data.lastModify
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            try self.context.save()
            return true
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
}
