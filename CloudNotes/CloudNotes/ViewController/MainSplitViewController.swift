//
//  MainSplitViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationEmbeddedListTableViewController = UINavigationController(rootViewController: ListTableViewController())
        let navigationEmbeddedTextViewController = UINavigationController(rootViewController: TextViewController())
        
        self.viewControllers = [navigationEmbeddedListTableViewController, navigationEmbeddedTextViewController]
        
        // 테이블뷰의 비율
//        self.preferredPrimaryColumnWidthFraction = 1/3
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
