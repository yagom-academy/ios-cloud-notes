//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    lazy var addMemoButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNavigationBar()
    }
    
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        self.view.addSubview(tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = addMemoButton
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "똘기떵이호치새초미자축인묘"
        cell.predescriptionLabel.text = "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine.\n\nI am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now.\n\nWhen, while the lovely valley teems with vapour around me, and the meridian sun strikes the upper surface of the impenetrable foliage of my trees, and but a few stray gleams steal into the inner sanctuary, I throw myself down among the tall grass by the trickling stream; and, as I lie close to the earth, a thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath"
        cell.dateLabel.text = "1608651333"
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    
}
