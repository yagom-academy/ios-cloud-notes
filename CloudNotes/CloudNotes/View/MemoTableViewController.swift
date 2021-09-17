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

    lazy var viewModel = {
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
        initViewModel()

        let request: NSFetchRequest<Note> = Note.fetchRequest()
        PersistanceManager.shared.deleteAll(request: request)
        let notes = PersistanceManager.shared.fetch(request: request)
        if notes.isEmpty {
            print("Deleted all")
        }
    }

    // MARK: - Methods
    func initViewModel() {
        viewModel.fetchNote()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc func saveData() {
        let mockNote = Memo(title: "Sample",
                            body: "Mock Data",
                            lastModified: 1608651333)
        let result = PersistanceManager.shared.saveNote(note: mockNote)

        if result {
            print("Saved note successful")
        } else {
            print("Failed to save")
        }

        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - View methods
extension MemoTableViewController {

    func initView() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(saveData))

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
}
