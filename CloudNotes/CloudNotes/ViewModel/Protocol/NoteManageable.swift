//
//  NoteManageable.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/17.
//

import Foundation
import UIKit.UIApplication
import CoreData

protocol NoteManageable {
    var notes: Observable<[NoteData]> { get set }
    func getAllNotes() throws -> [NoteData]
    func createNote()
    func updateNote(_ note: String, _ lastModifiedDate: Date, _ indexPath: IndexPath)
    func deleteNote(indexPath: IndexPath)
}

extension NoteManageable {
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func setNote(title: String, lastModifiedDate: Date, body: String, at indexPath: IndexPath) {
        notes.value[indexPath.row].title = title
        notes.value[indexPath.row].lastModifiedDate = lastModifiedDate
        notes.value[indexPath.row].body = body
    }
    
    func isDataExist() -> Bool {
        guard let count = try? context.count(for: NoteData.fetchRequest()) else {
            print(DataError.FailedToGetData)
            return false
        }
        return count > 0
    }
    
    func getAllNotes() throws -> [NoteData] {
        do {
            let notes = try context.fetch(NoteData.fetchRequest()).sorted(by: { first, last in
                return (first.lastModifiedDate ?? Date()) > (last.lastModifiedDate ?? Date())
            })
            return notes
        } catch {
            throw DataError.FailedToGetData
        }
    }
    
    func createNote() {
        let newNote = NoteData(context: context)
        newNote.title = NoteLiteral.empty
        newNote.lastModifiedDate = Date()
        newNote.body = NoteLiteral.empty
        
        do {
            try context.save()
            notes.value = try self.getAllNotes()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateNote(_ note: String, _ lastModifiedDate: Date, _ indexPath: IndexPath) {
        let separatedNotes = note.split(separator: NoteLiteral.LineBreak.Character, maxSplits: 1).map { (value) -> String in
            return String(value)
        }
        
        if separatedNotes.count == 0 {
            setNote(title: NoteLiteral.empty, lastModifiedDate: lastModifiedDate, body: NoteLiteral.empty, at: indexPath)
        } else if separatedNotes.count == 1 {
            setNote(title: separatedNotes[NoteLiteral.titleIndex], lastModifiedDate: lastModifiedDate, body: NoteLiteral.empty, at: indexPath)
        } else {
            setNote(title: separatedNotes[NoteLiteral.titleIndex], lastModifiedDate: lastModifiedDate, body: separatedNotes[NoteLiteral.bodyIndex], at: indexPath)
        }

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteNote(indexPath: IndexPath) {
        context.delete(notes.value[indexPath.row])
        
        do {
            try context.save()
            notes.value = try self.getAllNotes()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
