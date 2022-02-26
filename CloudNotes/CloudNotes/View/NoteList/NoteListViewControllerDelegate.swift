import Foundation
// MARK: - Declare NoteListViewController Delegate
protocol NoteListViewControllerDelegate: AnyObject {

func noteListViewController(
    _ viewController: NoteListViewController,
    didSelectedCell indexPath: IndexPath
)

func noteListViewController(addButtonTapped viewController: NoteListViewController)

func noteListViewController(
    _ viewController: NoteListViewController,
    cellToDelete indexPath: IndexPath
)

func noteListViewController(
    _ viewController: NoteListViewController,
    cellToShare indexPath: IndexPath
)

func noteListViewController(
    _ viewController: NoteListViewController,
    cellToUpload indexPath: IndexPath
)
}
