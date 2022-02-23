//
//  MemoStorage.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/23.
//

import UIKit

final class MemoStorage {
    private let coreDataManager = CoreDataManager()
    private let dropboxManager = DropboxManager()
    
    func create(id: UUID = UUID(), title: String = .blank, body: String = .blank, lastModified: TimeInterval = Date().timeIntervalSince1970) {
        coreDataManager.create(id: id, title: title, body: body, lastModified: lastModified)
    }
    
    func fetchAll() -> [Memo] {
        return coreDataManager.fetchAll()
    }
    
    func delete(memo: Memo) {
        dropboxManager.delete(memo: memo)
        coreDataManager.delete(memo: memo)
    }
    
    func update(to memo: Memo, title: String, body: String) {
        coreDataManager.update(to: memo, title: title, body: body)
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
        let fetchedMemos = try? self.coreDataManager.context.fetch(request)
        
        return fetchedMemos?.isEmpty == true
    }
}
