import UIKit

class NoteListViewController: UIViewController {
    var dataStorage: DataStorage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorage = DataStorage()
        view.backgroundColor = .blue

    }
}


//extension NoteListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//}

//extension NoteListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataStorage?.assetData!.count ?? 1
        //TODO: Models.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      1
//    }
//}
