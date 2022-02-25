//
//  UITableView+Extension.swift
//  CloudNotes
//
//  Created by 이승재 on 2022/02/25.
//

import Foundation
import UIKit

extension UITableView {

    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError()
        }
        
        return cell
    }
}
