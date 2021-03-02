//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit
import CoreData

class MemoTableViewController: UIViewController {
    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

//    private var memos: [Memo]?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Memo> = {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                fatalError()
            }
        
            let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(Memo.date), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            return fetchedResultsController
        }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
        memoListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationItem()
    }
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddBarButton))
        navigationItem.title = "메모"
    }
    @objc func touchUpAddBarButton() {
        if let memoSplitViewController = splitViewController as? MemoSplitViewController {
            memoSplitViewController.showMemoViewController(nil)
        }
    }
}

//MARK: - TableView
extension MemoTableViewController {
    func configureTableView() {
        memoListTableView.delegate = self
        memoListTableView.dataSource = self
        memoListTableView.frame = view.frame
        view.addSubview(memoListTableView)
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: fetchedResultsController.object(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = fetchedResultsController.object(at: indexPath)
        if let memoSplitViewController = splitViewController as? MemoSplitViewController {
            memoSplitViewController.showMemoViewController(memo)
        }
    }
}
