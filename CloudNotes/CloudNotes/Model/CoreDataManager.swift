//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/14.
//

import Foundation
import CoreData

//CoreDataStack = 앱의 모델 layer 관리

//NSManagedObjectModel = Entity를 설명하는 Database 스키마
//NSManagedObjectContext =transaction, managed objects를 생성하고, 저장하고, 가져오는(fetch) 제공
//NSPersistentStoreCoordinator = persistent storage(영구 저장소)와 managed object model을 연결
//NSPersistentContainer = Core Data Stack을 나타내는 필요한 모든 객체를 포함

class CoreDataManager {
    static var shared = CoreDataManager ()
    
    //컨테이너 설정
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //컨텍스트 가져오기
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    
    private init() { }
    
    func fetch<T: NSManagedObject> (request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func insertMemo (_ memo: Memo) {
        let entity = NSEntityDescription.entity(forEntityName: "MemoData", in: self.context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto:self.context)
            managedObject.setValue(memo.title, forKey: "name")
            managedObject.setValue(memo.body, forKey: "body")
            managedObject.setValue(memo.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete (memo: NSManagedObject){
        self.context.delete(memo)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
