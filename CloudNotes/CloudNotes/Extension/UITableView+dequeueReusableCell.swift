//
//  UITableView+dequeueReusableCell.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("cell을 dequeue하는데 실패했습니다.")
        }
        
        return cell
    }
}
