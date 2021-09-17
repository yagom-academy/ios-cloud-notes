//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MenuViewController: UIViewController {
    // MARK: - Properties
    var splitView: SplitViewController?
    
    let tableView = UITableView()
    private var data = [CloudNoteItem]()
    
    // MARK: - LifeCycles
    override func loadView() {
        super.loadView()
        do {
            data = try ParsingManager().parse(fileName: "sample")
        } catch {
            print(ParsingError.parsingError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellIdentifier)
        configureTableViewLayout()
    }

    // MARK: - Methods
    func update(indexPath: IndexPath) {
        data[indexPath.row].body = splitView?.detail?.textView.text ?? ""
    }
    
    private func configureNavigationItem() {
        self.title = "메모"
    }
    
    private func configureTableViewLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellIdentifier, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        let customCellViewModel = CustomViewModel<CustomCell>(customType: cell)

        customCellViewModel.customType.title.text = data[indexPath.row].title
        customCellViewModel.customType.lastModification.text = dateFormatter.string(from: data[indexPath.row].lastModified)
        customCellViewModel.customType.shortDescription.text = data[indexPath.row].body
        cell.bind(with: customCellViewModel)
        return cell
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        splitView?.detail?.indexPath = indexPath
        guard let detail = splitView?.detail else {
            return
        }
        
        detail.update(data: data, indexPath: indexPath)
        let navi :UINavigationController = UINavigationController(rootViewController: detail)
        self.showDetailViewController(navi, sender: self)
    }
    
}
