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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    func loadSampleData() {
//        guard let assetData: NSDataAsset = NSDataAsset(name: "sample") else { return }
//        guard let memoData = try? JSONDecoder().decode([Memo].self, from: assetData.data) else { return }
//
//        self.memo = memoData
//    }
    
    func readMemo(index: Int) -> MemoData {
        return self.memo[index]
    }
    
    func countMemo() -> Int {
        return self.memo.count
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
    
    func getAllMemoData() {
        do {
            self.memo = try  context.fetch(MemoData.fetchRequest())
        }
        catch {
            // error
        }
    }
    
    func createMemoData() {
        let newMemoData = MemoData(context: context)
        newMemoData.title = "새로운 메모"
        newMemoData.body = ""
        newMemoData.lastModified = convertDouble()
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteMemoData(memo: MemoData) {
        context.delete(memo)
        
        do {
            try context.save()
            getAllMemoData()
        } catch {
            
        }
    }
    
    func updataMemoData(memo: MemoData, titleText: String, bodyText: String) {
        memo.title = titleText
        memo.body = bodyText
        memo.lastModified = convertDouble()
        
        do {
            try context.save()
        } catch {
            
        }
    }
}
