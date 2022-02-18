import Foundation
import CoreData

class CoreDataMemos {
  private var array = [Memo]()
  
  private lazy var entity = NSEntityDescription.entity(forEntityName: "\(Memo.self)", in: managedContext)
  private lazy var managedContext = persistentContainer.viewContext
  private lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "CloudNotes")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {

        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension CoreDataMemos {
  var count: Int {
    return array.count
  }
  
  var isEmpty: Bool {
    return array.isEmpty
  }
  
  private func insert(_ memo: Memo, at index: Int) throws {
    array.insert(memo, at: index)
    try managedContext.save()
  }
  
  func createFirst(title: String, body: String) throws {
    guard let entity = entity else { return }
    let memo = Memo(entity: entity, insertInto: managedContext)
    memo.title = title
    memo.body = body
    try insert(memo, at: 0)
  }
  
  func fetch() throws {
    let request = Memo.fetchRequest()
    let persistentData = try managedContext.fetch(request)
    array = persistentData
  }
}

extension CoreDataMemos {
  subscript(index: Int) -> Memo {
    return array[index]
  }
}
