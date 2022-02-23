import Foundation

protocol NoteListTableViewDelegate: AnyObject {
    
    func selectNote(with identifier: UUID?)
    func detailBarButtonItemDidTap()
    
}
