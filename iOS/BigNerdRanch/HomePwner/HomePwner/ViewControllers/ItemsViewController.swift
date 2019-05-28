//
//  ViewController.swift
//  HomePwner
//
//  Created by Nazmul Islam on 8/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStoreModel: ItemStoreViewModel!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         No need to use the following code now as we are using navigation controller
        
         // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
         
         **/
        
        // Make table view row height dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let item = itemStoreModel.createItem()
        /**
         We can insert row at particular index using insertRows() method
         if we can calculate the index path correctly, that way we won't
         need to call reloadData() every time.
        **/
        if let indexPath = itemStoreModel.getIndexPath(for: item) {
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            print("Something's wrong, can't find index path. Reloading table view!")
            tableView.reloadData()
        }
    }
    
    /**
     The follwing code is obsolete as we use system provided `editButtonItem`
     that has built in toggle mechanism
 
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // Currently in editing mode
        if isEditing {
            // Change title of editing button as we are going to normal state
            sender.setTitle("Edit", for: .normal)
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change title of editing button as we are going to editing state
            sender.setTitle("Done", for: .normal)
            // Turn on editing mode
            setEditing(true, animated: true)
        }
    }
     **/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemStoreModel.numberOfSection
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemStoreModel.getTitleForHeader(in: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStoreModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ItemCell.self)", for: indexPath) as? ItemCell, let item = itemStoreModel.getItem(using: indexPath) else {
            // `No More Item` cell
            let cell = UITableViewCell()
            cell.textLabel?.text = "No More Items!"
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        cell.nameLabel.text = item.name
        cell.valueLabel.text = "$\(item.valueInDollars)"
        cell.serialNumberLabel.text = item.serialNumber
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 2
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        // Change the title of the confirmation button of table view cell delete, default title is `Delete`
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking for a delete command..
        if editingStyle == .delete {
            guard let item = itemStoreModel.getItem(using: indexPath) else {
                return
            }
            
            let title = "Delete \(item.name)"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                self.itemStoreModel.removeItem(item)
                self.imageStore.deleteImage(forKey: item.itemKey)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // Prevent table view to move item from one section to another
        guard itemStoreModel.canMoveItem(from: sourceIndexPath, to: proposedDestinationIndexPath) else {
            return sourceIndexPath
        }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStoreModel.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowItemDetail":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            guard let item = itemStoreModel.getItem(using: indexPath) else {
                return
            }
            
            guard let detailViewController = segue.destination as? DetailViewController else {
                return
            }
                
            detailViewController.item = item
            detailViewController.imageStore = imageStore
        default:
            preconditionFailure("Unexpected segue identifier!. Expected: ShowItemDetail, Found: \(String(describing: segue.identifier))")
        }
    }
}
