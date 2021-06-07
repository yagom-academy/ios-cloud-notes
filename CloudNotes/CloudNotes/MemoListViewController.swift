//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/01.
//

import UIKit

class MemoListViewController: UITableViewController {
    
    var memoList = [MemoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.title = "메모"
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: "MemoListCell")
        
        setNavigationBarButton()
        parseMemoData()
    }
    
    @objc private func addToMemo() {
        let memoFormViewController = MemoFormViewController()
        navigationController?.pushViewController(memoFormViewController, animated: true)
    }
    
    private func setNavigationBarButton() {
        let newMemo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToMemo))
        navigationItem.rightBarButtonItem = newMemo
    }
    
    private func parseMemoData() {
        let decoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return
        }
        let data = dataAsset.data
        
        do {
            let result = try decoder.decode([MemoData].self, from: data)
            memoList = result
        } catch {
            print("parsing failed")
        }
    }
    
    private func convertDateFormat(date: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        let convertDate = Date(timeIntervalSince1970: Double(date))
        let result = dateFormatter.string(from: convertDate)
        
        return result
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListCell") as? MemoListCell else {
            return MemoListCell()
        }
        
        let memoData = memoList[indexPath.row]
        let date = convertDateFormat(date: memoData.lastModified)
        
        cell.accessoryType = .disclosureIndicator
        cell.title.text = memoData.title
        cell.date.text = date
        cell.preview.text = memoData.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoFormViewController = MemoFormViewController()
        memoFormViewController.MemoTextView.text = """
        \(memoList[indexPath.row].title)

        \(memoList[indexPath.row].body)
        """
        self.navigationController?.pushViewController(memoFormViewController, animated: true)
    }
}
