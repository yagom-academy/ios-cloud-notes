//
//  PrimaryChildTableViewController.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/06.
//

import UIKit

class PrimaryChildViewController: UITableViewController {
    private var notes: [Note]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNotes()
    }
    
    func initNotes() {
        let sampleDataFileName = "sample"
        let sampleData = NSDataAsset(name: sampleDataFileName)?.data
        let parsedData = sampleData.parse(type: [Note].self)
        
        switch parsedData {
        case .success(let parsedData):
            notes = parsedData
        case .failure(let error):
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailRootViewController = SecondaryChildViewController()
        let detailViewController = UINavigationController(
            rootViewController: detailRootViewController
        )
        showDetailViewController(detailViewController, sender: self)
    }

}
