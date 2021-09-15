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
    let entitiyName = "MemoData"
    //컨테이너 설정
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
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
    
    func fetchMemo () -> [Memo] {
        var memoList = [Memo]()
        let fetchRequest: NSFetchRequest<MemoData> = MemoData.fetchRequest()
        
        do {
            let fetchResult = try self.context.fetch(fetchRequest)
            for memo in fetchResult{
                let title = memo.title
                let body = memo.body
                let date = memo.date
                let identifier = memo.objectID
                
                guard let unwraapedTitle = title, let unwraapedBody = body else {
                    return []
                }
                
                let model = Memo(title: unwraapedTitle, body: unwraapedBody, date: date, identifier: identifier)
                memoList.append(model)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
        
        return memoList
    }
    
    func insertMemo (_ memo: Memo) {
        let entity = NSEntityDescription.entity(forEntityName: entitiyName, in: self.context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto:self.context)
            managedObject.setValue(memo.title, forKey: "title")
            managedObject.setValue(memo.body, forKey: "body")
            managedObject.setValue(memo.date, forKey: "date")
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete (identifier: NSManagedObjectID){
        let memo = self.context.object(with: identifier)
        self.context.delete(memo)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
