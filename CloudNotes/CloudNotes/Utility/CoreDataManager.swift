//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/11.
//

import UIKit
import CoreData

class CoreDataManager {
    let dropboxManager = DropboxManager()
    lazy var context = persistentContainer.newBackgroundContext()
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CloudNotes")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("persistent stores 로드에 실패했습니다 : \(error)")
            }
        }
        return container
    }()
    
    // MARK: - CoreData CRUD
    
    func create(id: UUID = UUID(), title: String = .blank, body: String = .blank, lastModified: TimeInterval = Date().timeIntervalSince1970) {
        guard let memoEntity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else {
            return
        }
        
        let memoManagedObject = NSManagedObject(entity: memoEntity, insertInto: context)
        
        memoManagedObject.setValue(id, forKey: "id")
        memoManagedObject.setValue(title, forKey: "title")
        memoManagedObject.setValue(body, forKey: "body")
        memoManagedObject.setValue(lastModified, forKey: "lastModified")
        
        saveContext()
    }
    
    func fetchAll() -> [Memo] {
        let request = Memo.fetchRequest()
        let fetchedMemo = try? context.fetch(request)
        return fetchedMemo ?? []
    }
    
    func delete(memo: Memo) {
        dropboxManager.delete(memo: memo)
        context.delete(memo)
        saveContext()
    }
    
    func update(to memo: Memo, title: String, body: String) {
        let currentDate = Date().timeIntervalSince1970
        memo.setValue(title, forKey: "title")
        memo.setValue(body, forKey: "body")
        memo.setValue(currentDate, forKey: "lastModified")
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Dropbox Synchronization
    
    func connectDropbox(viewController: UIViewController) {
        dropboxManager.connectDropbox(viewController: viewController)
    }
    
    func upload(memo: Memo) {
        dropboxManager.upload(memos: [memo])
    }
    
    func uploadAll() {
        let fetchedMemos = fetchAll()
        dropboxManager.upload(memos: fetchedMemos)
    }
    
    func synchronizeCoreDataToDropbox() {
        dropboxManager.fetchFilePaths { metaDatas in
            metaDatas.forEach { metaData in
                self.dropboxManager.download(from: "/\(metaData.name)") {
                    if self.hasNoMemo(with: $0.id) {
                        self.create(id: $0.id, title: $0.title, body: $0.body, lastModified: $0.clientModified)
                        NotificationCenter.default.post(name: .tableViewNeedUpdate, object: nil)
                    }
                }
            }
        }
    }
    
    func hasNoMemo(with id: UUID) -> Bool {
        let request = Memo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let fetchedMemos = try? self.context.fetch(request)
        
        return fetchedMemos?.isEmpty == true
    }
}
