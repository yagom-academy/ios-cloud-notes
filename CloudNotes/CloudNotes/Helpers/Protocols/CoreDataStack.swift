//
//  CoreDataStack.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/14.
//

import CoreData

protocol CoreDataStack {
    var persistentContainer: NSPersistentCloudKitContainer { get }
    var fetchedResultsController: NSFetchedResultsController<Note>? { get }
    func saveContext()
    func loadSavedNotes(with noteManager: NSFetchedResultsControllerDelegate)
}
