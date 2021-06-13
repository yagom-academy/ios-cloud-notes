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
    
    func readMemo(index: Int) -> MemoData {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
    }
    
    func configureLastSelectIndex(index: Int) {
        self.lastSelectIndex = index
    }
    
    func memoDataText(data: MemoData) -> String {
        guard let title = data.title else {
            return "non title"
        }
        guard let body = data.body else {
            return "non body"
        }
        
        return title + body
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
        newMemoData.title = "새로운 메모"
        newMemoData.body = ""
        newMemoData.lastModified = convertDouble()
        do {
            try context.save()
            getAllMemoData()
        } catch {
            
        }
    }
    
    func deleteMemoData() {
        let memoData = self.memo[lastSelectIndex]
        context.delete(memoData)
        
        do {
            try context.save()
            getAllMemoData()
        } catch {
            
        }
    }
    
    func updataMemoData(titleText: String, bodyText: String) {
        self.memo[lastSelectIndex].title = titleText
        self.memo[lastSelectIndex].body = bodyText
        self.memo[lastSelectIndex].lastModified = convertDouble()
        
        do {
            try context.save()
            getAllMemoData()
        } catch {
            
        }
    }
    
}
