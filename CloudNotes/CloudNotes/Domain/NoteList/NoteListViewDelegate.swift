import Foundation

protocol NoteListViewDelegate: AnyObject {
    func passNote(index: Int)

    func creatNote()
}
