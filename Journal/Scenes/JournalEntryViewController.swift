//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import UIKit
import CoreData

class JournalEntryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField! // Title
    @IBOutlet weak var journalTextView: UITextView! // Entry
    @IBOutlet weak var usedCharactersLabel: UILabel! // Word count
    @IBOutlet weak var dateLabel: UILabel! // date
    
    var jEntry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextView.delegate = self
        titleTextField.delegate = self
        configureView()
        
        if let split = splitViewController {
            if !split.isCollapsed {
                navigationItem.leftBarButtonItem = nil
            }
        } else {
            return
        }
    }

    // if user hasn't put anything into the fields (empty) placeholders show
    func configureView() {
        guard let inputSection = jEntry else {
            // entry placeholder
            journalTextView.text = "Please enter something..."
            journalTextView.textColor = UIColor.lightGray
            // title placeholder
            titleTextField.text = "Title..."
            titleTextField.textColor = UIColor.darkGray
            //current date
            dateLabel.text = setDate()
            return
        }
        
        // user's input as the selection rather than the placeholder
        titleTextField.text = inputSection.title
        journalTextView.text = inputSection.entry
        
        // character count
        if let characterCount = inputSection.entry?.count {
            usedCharactersLabel.text = "\(characterCount)/250"
        }
        // date
        dateLabel.text = inputSection.timestamp
    }
    
    // date formatting (australian day/month/year)
    func setDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let currentDate = Date()
        let dateString = formatter.string(from: currentDate)
        return dateString
    }
    
    // saving the entry function
    func saveEntry() {
        let managedObj = CDirector.shared.managedObjectContext
    
        guard let inputSection = jEntry else {
            // journalAdd is the 'save'
            let journalAdd = JournalEntry(context: managedObj)
            
            // saving title of the journal
            journalAdd.title = titleTextField.text
            // saving entry of the journal
            journalAdd.entry = journalTextView.text
            // saving allocated date of new journal entry
            journalAdd.timestamp = dateLabel.text
            
            do {
                try managedObj.save()
            }
            catch {
                print("Error") // if error in save, needs a 'catch'
            }
            return
        }
        
        // if user re-edits the file later on it will be saved
        inputSection.title = titleTextField.text
        inputSection.entry = journalTextView.text
        inputSection.timestamp = setDate()
        do {
            try managedObj.save()
        }
        catch {
            print("Error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnAfterSave" {
            saveEntry()
        }
    }
    
    // Function for when the save button is pressed
    // checks for:
    //      - no empty fields
    //      - no placeholders
    //      - Returns to journal entries screen once saved
    @IBAction func saveButtonTapped(_ sender: Any) {
       
        if titleTextField.text == nil || titleTextField.text == "Title..." {
            alertFound(title: "Error", message: "Please use a title")
        }
        else if journalTextView.text == nil || journalTextView.text == "Journal entry..." {
            alertFound(title: "Error", message: "Please enter something")
        }
        // check then return to entries screen
        else {
            if let splitDisp = splitViewController {
                if splitDisp.isCollapsed {
                    performSegue(withIdentifier: "returnAfterSave", sender: Any?.self)
                }
                else {
                    if let JournalViewController = splitViewController?.primaryViewController {
                        saveEntry()
                        JournalViewController.viewWillAppear(true)
                        JournalViewController.tableView.reloadData()
                        print("reloaded")
                        jEntry = nil
                        configureView()
                    }
                    return
                }
            }
        }
    }
}
