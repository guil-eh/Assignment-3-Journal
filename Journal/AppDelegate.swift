//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UISplitViewControllerDelegate, UIApplicationDelegate  {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
    }
    
    // Active to inactive state
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    //Restart paused tasks
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    // Save data then close app
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // Save state if returned to later
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    // Called from background to enter the active scene
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    // Container view controller for hierarchial interface
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController
        else {
            return false
        }
        guard let topAsJournalEntryController = secondaryAsNavController.topViewController as? JournalEntryViewController
        else {
            return false
        }
        if topAsJournalEntryController.jEntry == nil {
            return true
        }
            return false
    }
}
