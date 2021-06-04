//
//  TutorialViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/04.
//

import UIKit

class TutorialViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getAllItems() {
        do {
            let items = try context.fetch(MemoListItem.fetchRequest())
        } catch {
            // error
        }
    }
    
    func createItem(title: String) {
        let newItem = MemoListItem(context: context)
        newItem.title = title
        newItem.lastModifiedDate = Date()
        
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func updateItem(item: MemoListItem, newTitle: String, newBody: String, lastModifiedDate: Date ) {
        item.title = newTitle
        item.body = newBody
        item.lastModifiedDate = lastModifiedDate
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteItem(item: MemoListItem) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
}
