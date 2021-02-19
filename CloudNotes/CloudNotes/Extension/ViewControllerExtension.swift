//
//  ViewControllerExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error, okHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okHandler)
        let cancleAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
