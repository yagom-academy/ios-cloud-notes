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
    private var specifyNote: Note?
    
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
        let newNote = Note(context: noteManager.context)
        newNote.title = ""
        newNote.body = ""
        newNote.lastModify = Date()
        noteManager.insert(newNote)
        noteDelegate?.deliverToDetail(nil, first: true, index: IndexPath(item: 0, section: 0))
    }
    
    func textViewIsEmpty(_ first: Bool) {
        if first == false { return }
        let data = noteManager.specify(IndexPath(row: 0, section: 0))
        self.noteManager.delete(data)
    }
    
    func updateTextToCell(_ data: String, isTitle: Bool, index: IndexPath?) {
        self.noteManager.update(data, isTitle, notedata: specifyNote!)
    }
    
    private func fetchList() {
        switch noteManager.fetch() {
        case .success(_):
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .failure(let error):
            alterError(CoreDataError.fetch(error).errorDescription)
        }
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
    
    func deleteEmptyNote() {
        updateData()
        guard let data = noteData else { return }
        let removeData = data[0]
        
        if self.noteListManager.delete(removeData.objectID!) {
            self.noteData?.remove(at: 0)
            self.tableView.deleteRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
        }
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
        specifyNote = noteManager.specify(indexPath)
        noteDelegate?.deliverToDetail(specifyNote, first: false, index: indexPath)
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
