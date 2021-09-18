//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit
import CoreData

class MemoTableViewController: UITableViewController {

    // MARK: - Properties
    private let isCompact: Bool

    var viewModel = {
        NoteViewModel()
    }()

    // MARK: - Initializer
    init(isCompact: Bool) {
        self.isCompact = isCompact
        super.init(style: UITableView.Style.plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        fetchViewModel()
    }

    // MARK: - Methods
    func fetchViewModel() {
        viewModel.fetchNote()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc func saveData() {
        let mockNote = Memo(title: ["111", "222", "333"].randomElement(),
                            body: ["444", "555", "666"].randomElement(),
                            lastModified: Int(Date().timeIntervalSince1970))
        let result = PersistanceManager.shared.saveNote(note: mockNote)

        if result {
            print("Saved note successful")
        } else {
            print("Failed to save")
        }

        fetchViewModel()
    }

    @objc func deleteAllData() {
        viewModel.deleteAllNote()
    }
}

// MARK: - View methods
extension MemoTableViewController {

    func initView() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(saveData))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                                target: self,
                                                                action: #selector(deleteAllData))

        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - Table view data source
extension MemoTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memoCellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MemoTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as? MemoTableViewCell {
            cell.noteCellViewModel = viewModel.getCellViewModel(at: indexPath)

            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Table view delegate
extension MemoTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = MemoDetailViewController()

        if self.isCompact {
            detailViewController.configure(with: viewModel.memoCellViewModels[indexPath.row])
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            detailViewController.configure(with: viewModel.memoCellViewModels[indexPath.row])
            let navigation = UINavigationController(rootViewController: detailViewController)
            self.showDetailViewController(navigation, sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uuid = viewModel.getCellViewModel(at: indexPath).uuid
            let result = PersistanceManager.shared.deleteNote(uuid: uuid)

            if result {
                print("A note deleted")
            } else {
                print("Error to delete a note")
            }
        }

        fetchViewModel()
    }
}
