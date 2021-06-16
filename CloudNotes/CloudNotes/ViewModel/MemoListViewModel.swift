//
//  MemoListViewModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit
import CoreData

final class MemoListViewModel {
    private var memo: [MemoData] = []
    private var lastSelectIndex = 0
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var editingMemo: MemoData?
    
    init() {
        self.getAllMemoData()
    }
    
    func readMemo(index: Int) -> MemoData {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
    }
    
    func setupEditingMemo(index: Int) {
        self.editingMemo = self.memo[index]
    }
    
    func memoDataText(data: MemoData) -> String {
        guard let title = data.title,
              let body = data.body else {
            return "non data"
        }
        
        return "\(title)\(body)"
    }
    
}

extension MemoListViewModel {
    func convertDate(date: Double) -> String {
        let result = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: result)
    }
    
    func convertDouble() -> Double {
        let nowDate = Date()
        let timeInterval = nowDate.timeIntervalSince1970
        return Double(timeInterval)
    }
    
}

extension MemoListViewModel {
    
    func fetch() -> [MemoData] {
        let fetchRequest = NSFetchRequest<MemoData>(entityName: "MemoData")
        let sort = NSSortDescriptor(key: "lastModified", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let result = try! context.fetch(fetchRequest)
        
        return result
    }
    
    func getAllMemoData() {
        self.memo = self.fetch()
    }
    
    func createMemoData() {
        let newMemoData = MemoData(context: context)
        newMemoData.title = ""
        newMemoData.body = ""
        newMemoData.lastModified = convertDouble()
        do {
            try context.save()
            getAllMemoData()
        } catch {
            MemoError.failCreate
        }
    }
    
    func deleteMemoData(data: MemoData) {
        context.delete(data)
        
        do {
            try context.save()
            getAllMemoData()
        } catch {
            MemoError.failDelete
        }
    }
    
    func updateMemoData(titleText: String, bodyText: String, data: MemoData) {
        data.title = titleText
        data.body = bodyText
        data.lastModified = convertDouble()
        
        do {
            try context.save()
            getAllMemoData()
        } catch {
            MemoError.failUpdate
        }
    }
    
}
