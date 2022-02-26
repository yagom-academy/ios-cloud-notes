import Foundation

// MARK: - Declare NoteListViewController Datasource
protocol NoteListViewControllerDataSource: AnyObject {
    
    func noteListViewControllerNumberOfData(
        _ viewController: NoteListViewController
    ) -> Int
    
    func noteListViewControllerSampleForCell(
        _ viewController: NoteListViewController,
        indexPath: IndexPath
    ) -> MemoType?
}
