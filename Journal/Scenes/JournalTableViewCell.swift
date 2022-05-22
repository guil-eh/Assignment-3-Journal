//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleForEntry: UILabel!
    @IBOutlet weak var dateForEntry: UILabel!
    @IBOutlet weak var entryText: UILabel!
    
    static let reuseIdentifier = "JournalCell"
    
    // awakeFromNib() preps the receiver for a given service after it has been loaded from the interface builder or from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // setSelected() applys the state of a cell then will animate the transitioning between states
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
