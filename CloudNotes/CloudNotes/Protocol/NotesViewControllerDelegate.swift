import Foundation

protocol NotesViewControllerDelegate: AnyObject {
    func updateData(at index: Int)
    func moveCell(at index: Int)
    func deleteCell(indexPath: IndexPath)
}
