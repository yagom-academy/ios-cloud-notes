import Foundation

protocol NoteTableViewDelegate: AnyObject {
    
    func selectNote(with identifier: UUID?)
    func detailBarButtonItemDidTap()
    
}
