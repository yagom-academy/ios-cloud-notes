//
//  DetailTextViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import UIKit

class DetailTextViewController: UIViewController {

    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(textView)
        setTextViewAnchor()
        // Do any additional setup after loading the view.
    }
    
    private func setTextViewAnchor() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
            .isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
            .isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
            .isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            .isActive = true
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
