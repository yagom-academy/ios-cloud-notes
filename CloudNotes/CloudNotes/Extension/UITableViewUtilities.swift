import UIKit

extension UITableView {
    
    func register<Cell: UITableViewCell>(_: Cell.Type) where Cell: TypeNameConvertible {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
}
