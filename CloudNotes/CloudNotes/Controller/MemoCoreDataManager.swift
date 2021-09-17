//
//  MemoDataAccessObject.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/09.
//

import UIKit
import CoreData

class MemoCoreDataManager {
    enum CoreDataKey: CustomStringConvertible {
        case entityName
        case sortDesc
        
        var description: String {
            switch self {
            case .entityName:
                return "Memo"
            case .sortDesc:
                return "lastModified"
            }
        }
    }
    static let shared = MemoCoreDataManager()
    private var listResource: [MemoData] {
        return fetchData()
    }
//    @objc dynamic var listResource: [MemoData] = []
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    var listCount: Int {
        return listResource.count
    }
    
    subscript (index: Int) -> MemoData {
        return listResource[index]
    }
    
    func fetchData() -> [MemoData] {
        var memoList = [MemoData]()
        let fetchRequest: NSFetchRequest<MemoManagedObject> = MemoManagedObject.fetchRequest()
        
        let lastModifiedDesc = NSSortDescriptor(key: CoreDataKey.sortDesc.description, ascending: false)
        fetchRequest.sortDescriptors = [lastModifiedDesc]
        
        do {
            let fetchedSet = try self.context.fetch(fetchRequest)
            for record in fetchedSet {
                let title = record.title
                let body = record.body
                let lastModified = record.lastModified
                
                let memoData = MemoData(title, body, lastModified, record.objectID)
                memoList.append(memoData)
            }
            return memoList
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.fetchData : %s", error.localizedDescription)
            return []
        }
    }
    
    func insertData(_ data: MemoModel, completion: (() -> Void)?) {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: CoreDataKey.entityName.description, into: self.context) as? MemoManagedObject else {
            NSLog("에러처리 필요 - MemoDataAccessObject.insertData")
            return
        }
        object.title = data.title
        object.body = data.body
        object.lastModified = data.lastModified
        do {
            try self.context.save()
            completion?()
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.insertData : %s", error.localizedDescription)
        }
    }
    
    func deleteData(at objectID: NSManagedObjectID, completion: (() -> Void)?) {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do {
            try self.context.save()
            completion?()
        } catch {
            NSLog("에러처리 필요 - MemoDataAccessObject.deleteData : %s", error.localizedDescription)
        }
    }
    
    func editData(by data: MemoData, completion: (() -> Void)?) {
        guard let objectID = data.objectID,
              let object = self.context.object(with: objectID) as? MemoManagedObject else {
            NSLog("에러처리 필요 - MemoDataAccessObject.editData : 수정할 객체 object 바인딩 실패")
            return
        }
        object.title = data.title
        object.body = data.body
        object.lastModified = data.lastModified
        do {
            try self.context.save()
            completion?()
        } catch {
            self.context.rollback()
            NSLog("에러처리 필요 - MemoDataAccessObject.editData : %s", error.localizedDescription)
            return
        }
    }
}

extension MemoCoreDataManager {
    func readDataAsset() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: Strings.Asset.diet.description) else {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 파일 바인딩 실패")
            return
        }
        do {
            let result = try decoder.decode([MemoSample].self, from: dataAsset.data)
            
            for data in result {
                insertData(data, completion: nil)
            }
        } catch {
            NSLog("에러처리 필요 - PrimaryViewController.readDataAsset : 디코딩 실패")
            return
        }
    }
}
