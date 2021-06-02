//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/01.
//

import UIKit

class NoteSplitViewController: UISplitViewController {
    var first: ViewController1!
    var second: ViewController2!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        first = ViewController1()
        second = ViewController2()

        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
        
        viewControllers = [first, second]
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

class ViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.view.frame.height * 1/12)
    }
}

class NoteTableCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.lineBreakStrategy = .hangulWordPriority
        title.numberOfLines = 1
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        return title
    }()
    
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.preferredFont(forTextStyle: .headline)
        return date
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = UIColor.lightGray
        description.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraint() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -10),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}

class ViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        view.addSubview(label)
        label.text = "second"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


