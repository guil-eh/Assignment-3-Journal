//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import UIKit
import CoreData

class JournalViewController: UITableViewController, UISearchControllerDelegate, UISplitViewControllerDelegate {

   @IBOutlet weak var writeEntryButton: UIBarButtonItem!
   
   var JournalEntryViewController: JournalEntryViewController? = nil
   var journalEntries: [JournalEntry] = []
   let searchController = UISearchController(searchResultsController: nil)
   var searchResults = [JournalEntry]()
   var iPad = false //Incase user has an iPad screen not a phone (used later)
   private var collapseJournalEntryViewController = true
   
   override func viewDidLoad() {
      super.viewDidLoad()
      navigationItem.leftBarButtonItem = editButtonItem
      
      // Search bar
      searchController.searchResultsUpdater = self
      searchController.delegate = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search..."
      navigationItem.hidesSearchBarWhenScrolling = false
      navigationItem.searchController = searchController
      
      // Make app fit to appropriate display size the user is using
      if let splitDisp = splitViewController {
         let controllers = splitDisp.viewControllers
         JournalEntryViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? JournalEntryViewController
         splitDisp.delegate = self
         if splitDisp.displayMode == .primaryHidden {
            splitDisp.preferredDisplayMode = .allVisible
            iPad = true
         }
         else {
            iPad = false
            return
         }
      }
   }
   
   func splitView(
      _ splitView: UISplitViewController,
      collapseSecondary secondaryViewController: UIViewController,
      onto primaryViewController: UIViewController) -> Bool {
      return true
   }
   
   // Data for display
   override func viewWillAppear(_ animated: Bool) {
      clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
      super.viewWillAppear(animated)
      self.definesPresentationContext = true
      let managedObj = CDirector.shared.managedObjectContext
      let infoRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
      do {
         journalEntries = try managedObj.fetch(infoRequest)
      }
      catch {
         print("Error")
      }
   }
   
   @objc //available to objective-C runtime for UIKit
   
   func insertNewObject(_ sender: Any) {
      let indexPath = IndexPath(row: 0, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
   }
   
   // if searchbar is empty
   func emptySearch() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
   }
   
   // Search bar filter function
   func searchFilter(_ searchText: String) {
      searchResults = journalEntries.filter({(journal: JournalEntry) -> Bool in
         return journal.title!.lowercased().contains(searchText.lowercased()) || journal.entry!.lowercased().contains(searchText.lowercased())
      } )
      tableView.reloadData()
   }
   
   func searchFiltering() -> Bool {
      return searchController.isActive && !emptySearch()
   }
   
   // Cancels searchbar activity thus returning to normal tableview
   func searchBarCancelButtonClicked(searchBar: UISearchBar) {
      searchBar.endEditing(true)
   }
   
   // Check if journal title entries are being filtered
   // using segue prepare
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showJournalEntry" {
         if let indexPath = tableView.indexPathForSelectedRow {
            let entry: JournalEntry
            if searchFiltering() {
               entry = searchResults[indexPath.row]
            } else {
               entry = journalEntries[indexPath.row]
            }
            
            let controller = (segue.destination as! UINavigationController).topViewController as! JournalEntryViewController
            controller.jEntry = entry
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
         }
      }
   }
   
   // tableview function (number of sections)
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if searchFiltering() {
         return searchResults.count
      } else {
         return journalEntries.count
      }
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! JournalTableViewCell
      let entry: JournalEntry
      
      if searchFiltering() {
         entry = searchResults[indexPath.row]
      } else {
         entry = journalEntries[indexPath.row]
      }
      
      // allocate values
      cell.titleForEntry?.text = entry.title
      cell.entryText?.text = entry.entry
      cell.dateForEntry.text = entry.timestamp
      
      return cell
   }
   
   // editing function for the tableview allowing to delete entries via top left button
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   // editing function continued; ability to delete entries
   // when deleted will look into the array then delete it from said array
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         if searchFiltering() {
            let managedObj = CDirector.shared.managedObjectContext
            managedObj.delete(searchResults[indexPath.row] as JournalEntry)
            do {
               try managedObj.save()
            }
            catch {
               print("Error")
            }
            
            searchResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
         else {
            let managedObj = CDirector.shared.managedObjectContext
            managedObj.delete(journalEntries[indexPath.row] as JournalEntry)
            do {
               try managedObj.save()
            }
            catch {
               print("Error")
            }
            
            journalEntries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
      }
      else if editingStyle == .insert {
      }
   }
   
   // From entries screen to writing screen using splitView and navigationcontroller
    @IBAction func writeButtonPressed(_ sender: Any) {
      if iPad == false {
        performSegue(withIdentifier: "showJournalEntry", sender: Any?.self)
      } else {
         if let splitDisp = splitViewController {
            let controllers = splitDisp.viewControllers
            JournalEntryViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? JournalEntryViewController
            JournalEntryViewController?.jEntry = nil
            JournalEntryViewController?.configureView()
         }
      }
    }
}
