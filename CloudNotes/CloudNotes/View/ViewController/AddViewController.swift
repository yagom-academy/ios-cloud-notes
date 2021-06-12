//
//  AddViewController.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/09.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
  private let textView: UITextView = {
    let textView = UITextView()
    textView.keyboardDismissMode = .onDrag
    
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    view.addSubview(textView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    textView.frame = view.bounds
  }
  
  func configureNavigationBar() {
    let doneButton = UIBarButtonItem(title: "완료",
                                     style: .plain,
                                     target: self,
                                     action: #selector(buttonPressed(_:)))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  @objc private func buttonPressed(_ sender: Any) {
    if textView.text != "" {
      addNewMemo()
      
      guard let listView =
              self.navigationController?.viewControllers.first as? ListViewController else {
        return
      }
      listView.updateUI()
    }
    
    self.navigationController?.popViewController(animated: true)
  }
  
  private func addNewMemo() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "MemoInfo", in: context)
    
    if let entity = entity {
      let memo = NSManagedObject(entity: entity, insertInto: context)
      setMemoValue(as: memo)
      
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  private func setMemoValue(as memo: NSManagedObject) {
    let text: String = textView.text
    
    let title: String = text.components(separatedBy: "\n").first ?? text
    memo.setValue(title, forKey: "title")
    
    let stringRange = text.index(text.startIndex, offsetBy: title.count+1) ... text.index(text.endIndex, offsetBy: -1)
    let body = String(text[stringRange])
    memo.setValue(body, forKey: "body")
    
    let currentDate = Date()
    let lastModified = DateConvertor().dateToNumber(date: currentDate)
    memo.setValue(lastModified, forKey: "lastModified")
  }
}
