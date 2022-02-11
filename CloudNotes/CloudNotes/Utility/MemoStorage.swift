//
//  MemoStorage.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/11.
//

import CoreData

struct MemoStorage {
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
}
