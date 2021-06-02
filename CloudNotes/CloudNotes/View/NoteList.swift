//
//  NoteList.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteList: UIViewController {
    var noteDatas: [NoteData] = []
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteData()
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NoteTableCell.self, forCellReuseIdentifier: "NoteCell")
        setConstraint()
    }
    
    @objc private func addNote() {
        // TODO: - 메모 추가
    }
    
    private func noteData() {
        guard let jsonData = NSDataAsset(name: "sample") else { return }
        guard let data = try? JSONDecoder().decode([NoteData].self, from: jsonData.data) else { return }
        noteDatas = data
    }
    
    private func setConstraint() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func convertUIntToDate(_ noteDate: UInt) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = Date(timeIntervalSince1970: TimeInterval(noteDate))
        return dateFormatter.string(from: date)
    }
    
    
    
    
}

extension NoteList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteTableCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = noteDatas[indexPath.row].title
        cell.dateLabel.text = convertUIntToDate(noteDatas[indexPath.row].lastModify ?? 0)
        cell.descriptionLabel.text = noteDatas[indexPath.row].description
        
        return cell
    }
}

extension NoteList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let secondView = splitViewController?.viewController(for: .secondary) as? ViewController2 else { return }
        secondView.textView.text = ""
        secondView.textView.insertText(noteDatas[indexPath.row].title ?? "")
        secondView.textView.insertText("\n\n")
        secondView.textView.insertText(noteDatas[indexPath.row].description ?? "")
        
        self.splitViewController?.showDetailViewController(secondView, sender: self)
    }
}
