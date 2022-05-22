//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import Foundation
import UIKit


// Search function
extension JournalViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchFilter(searchText)
    }
}

// Alert function
extension UIViewController {
    func alertFound(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
// Hierarchial interface
extension UISplitViewController {
    var primaryViewController: JournalViewController? {
        let navController = self.viewControllers.first as? UINavigationController
        return navController?.topViewController as? JournalViewController
    }
}

extension JournalEntryViewController {
    // Title length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 25
    }
    
    // Journal length
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        usedCharactersLabel.text = "\(textView.text.count)/250"
        return changedText.count < 250
    }
    
    // ENTRY SECTION --------
    // Colour text changes when adding entry
    // When user clicks on the entry section it will remove the placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // if textView is empty will put the placeholder "Please enter something..."
    // this is for the journal entry section
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter something..."
            textView.textColor = UIColor.lightGray
        }
    }
    // -----------------------
    
    //TITLE SECTION ----------
    // Colour text changes when adding the Title of the entry
    // When user clicks on the title section it will remove the placeholder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.darkGray {
           textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    // if textView is empty will put the placeholder "Title..."
    // this is for the Title section of the journal
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let uInput = textField.text?.isEmpty else {
            return
        }
        if uInput {
            textField.text = "Title..."
            textField.textColor = UIColor.darkGray
        }
        else {
            return
        }
    }
    // -----------------------
}
