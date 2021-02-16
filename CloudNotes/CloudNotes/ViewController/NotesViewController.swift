//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class NotesViewController: UIViewController {
    private let tableView = UITableView()
    var sampleData: [SampleData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        decodeJSONFile()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func decodeJSONFile() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let dataAssetName: String = "sample"
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: dataAssetName) else {
            return
        }
        
        do {
            self.sampleData = try jsonDecoder.decode([SampleData].self, from: dataAsset.data)
        } catch DecodingError.dataCorrupted(let context) {
            print("데이터가 손상되었거나 유효하지 않습니다.")
            print(context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
        } catch DecodingError.keyNotFound(let codingkey, let context) {
            print("주어진 키를 찾을수 없습니다.")
            print(codingkey.intValue ?? Optional(nil)! , codingkey.stringValue , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
        } catch DecodingError.typeMismatch(let type, let context) {
            print("주어진 타입과 일치하지 않습니다.")
            print(type.self , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("예상하지 않은 null 값이 발견되었습니다.")
            print(type.self , context.codingPath, context.debugDescription, context.underlyingError ?? "" , separator: "\n")
        } catch {
            print("그외 에러가 발생했습니다.")
        }
    }
}

// MARK: - TableView DataSource
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = sampleData[indexPath.row].title
        cell.lastModifiedDateLabel.text = "\(sampleData[indexPath.row].lastModifiedDate)"
        cell.bodyLabel.text = sampleData[indexPath.row].body
        return cell
    }
}
