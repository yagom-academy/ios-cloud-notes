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
        } catch DecodingError.dataCorrupted {
            debugPrint(JSONDecodingError.dataCorrupted.errorDescription!)
        } catch DecodingError.keyNotFound {
            debugPrint(JSONDecodingError.keyNotFound.errorDescription!)
        } catch DecodingError.typeMismatch {
            debugPrint(JSONDecodingError.typeMismatch.errorDescription!)
        } catch DecodingError.valueNotFound {
            debugPrint(JSONDecodingError.valueNotFound.errorDescription!)
        } catch {
            debugPrint(JSONDecodingError.unknown.errorDescription!)
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
        cell.lastModifiedDateLabel.text = sampleData[indexPath.row].convertFormatToString()
        cell.bodyLabel.text = sampleData[indexPath.row].body
        return cell
    }
}
