import UIKit
import Nuke

final class TableViewController: UITableViewController {
    
    internal let storage = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _navigationBarSetup()
        tableView.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier); #warning("tableView.register НИКУДА НЕ УБИРАТЬ!")
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.decelerationRate = .fast
        updaterGroup.notify(queue: .main, execute: { [self] in
            tableView.reloadData()
            _navigationBarRightActivityIndicator(hide: true)
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _ = cell as? CustomCell, let res = storage.database?.results else { return }
        if indexPath.row == (res.count - 8) {
            self.updater()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
//        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? CustomCell {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            cell.backgroundColor = .systemRed
//        }
    }
    
    //MARK: -- numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.database?.results.count ?? 0
    }

    //MARK: -- cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = storage.database?.results[indexPath.row]
        if let cell: CustomCell = (tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell) { // #warning("OK!")
            //MARK: Name Block
            cell.idname = result?.name.id
            cell.gender = result?.name.title
            cell.firstname?.text = result?.name.first
            cell.surname?.text = result?.name.last
            //MARK: Image Block
            cell.imageViewPhoto?.image = result?.picture.image
            cell.urlPackPhoto.append((
                result?.picture.thumbnailUrl ??
                result?.picture.mediumUrl ??
                result?.picture.largeUrl) ?? ""
            )
            cell.idpic = result?.picture.id // for extract from cache
            return cell
        } else {
            let defaultCell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: CustomCell.identifier)
            defaultCell.backgroundColor = UIColor.systemRed
            return defaultCell
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//
//extension UITableView {
//    func reloadDataSavingSelections() {
//        let selectedRows = indexPathsForSelectedRows
//
//        reloadData()
//
//        if let selectedRow = selectedRows {
//            for indexPath in selectedRow {
//                selectRow(at: indexPath, animated: false, scrollPosition: .none)
//            }
//        }
//    }
//}