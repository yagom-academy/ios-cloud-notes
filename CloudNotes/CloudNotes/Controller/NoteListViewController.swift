//
//  NoteListViewController.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit
import CoreData

protocol NoteListViewDelegate: AnyObject {
    func noteListView(didSeletedCell row: Int)
}

final class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = UITableView()
    
    weak var delegate: NoteListViewDelegate?
    var persistantManager: PersistantManager?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupConstraints()
        selectNote(with: 0)
        setupbackgroundLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundView?.isHidden = persistantManager?.notes.count == 0 ? false : true
    }
    
    private func setupNavigation() {
        title = "메모"
        let addButtonImage = UIImage(systemName: ImageNames.plusImageName)
        let rightButton = UIBarButtonItem(
          image: addButtonImage,
          style: .done,
          target: self,
          action: #selector(addEmptyNote)
        )
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    func updateListView(index: Int, noteInformation: NoteInformation) {
        if let note = persistantManager?.notes[index] {
            persistantManager?.update(object: note, noteInformation: noteInformation)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            view.endEditing(true)
        }
    }
    
    @objc func addEmptyNote() {
        tableView.performBatchUpdates {
            let emptyNoteInformation = NoteInformation(
                title: "새로운 메모",
                content: "추가 텍스트 없음",
                lastModifiedDate: Date().timeIntervalSince1970
            )
            persistantManager?.save(noteInformation: emptyNoteInformation)
            persistantManager?.notes = persistantManager?.fetch() ?? []
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        } completion: {_ in
            self.tableView.backgroundView?.isHidden = true
            self.tableView.reloadData()
            self.selectNote(with: 0)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            NoteListCell.self,
            forCellReuseIdentifier: NoteListCell.identifier
        )
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupbackgroundLabel() {
        let backgroundLabel = UILabel()
        backgroundLabel.text = "메모없음"
        backgroundLabel.textColor = .systemGray
        backgroundLabel.font = .preferredFont(forTextStyle: .title1)
        backgroundLabel.textAlignment = .center
        tableView.backgroundView = backgroundLabel
    }
    
    private func selectNote(with index: Int) {
        guard let noteInformations = persistantManager?.notes,
              noteInformations.count > 0 else {
               return
        }
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
}

// MARK: - Table View Delegate

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.noteListView(didSeletedCell: indexPath.row)
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return persistantManager?.notes.count ?? 0
    }
    
    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: NoteListCell.identifier,
          for: indexPath
        ) as? NoteListCell else {
            return UITableViewCell()
        }
        guard let information = persistantManager?.notes[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: information)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard let object = persistantManager?.notes[indexPath.row] else {
            return
        }
        if editingStyle == .delete {
            persistantManager?.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            persistantManager?.delete(object: object)
            if persistantManager?.notes.count == indexPath.row {
                selectNote(with: indexPath.row - 1)
            } else {
            selectNote(with: indexPath.row)
            }
        }
    }
}
