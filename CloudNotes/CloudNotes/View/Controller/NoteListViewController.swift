//
//  NoteList.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteListViewController: UIViewController {
    private lazy var noteListManager = NoteManager()
    private var cellView: UIView?
    private var noteData: [Note]?
    weak var noteDelegate: NoteDelegate?
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.showsVerticalScrollIndicator = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        setConfiguration()
        setConstraint()
        setCellView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    @objc private func addNote() {
        // TODO: - 메모 추가
        let add = Note(title: "새로운 메모 📄", body: nil, lastModify: nil)
        self.noteListManager.insert(add)
        noteData?.append(add)
        self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
    
    private func updateData() {
        noteData = noteListManager.fetch()
    }
    
    private func setCellView() {
        self.cellView = UIView()
        self.cellView?.layer.cornerRadius = 15
    }
    
    private func setConfiguration() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteListCell.self, forCellReuseIdentifier: "NoteCell")
    }
    
    private func setConstraint() {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteData == nil ? 0 : noteData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteListCell, let data = noteData else { return UITableViewCell() }
        cell.displayData(data[indexPath.row])

        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = noteData else { return }
        noteDelegate?.deliverToDetail(data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = noteData else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title:  "🗑", handler: { (ac: UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let removeData = data[indexPath.row]
            
            if self.noteListManager.delete(removeData.objectID!) {
                self.noteData?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                success(true)
            }
        })
        
        let shareAction = UIContextualAction(style: .normal, title:  "공유", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let shardNote = "\(data[indexPath.row].title ?? "") \n\n \(data[indexPath.row].body ?? "")"
            let activityViewController = UIActivityViewController(activityItems: [shardNote], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            success(true)
        })
        shareAction.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions:[deleteAction,shareAction])
    }
}
