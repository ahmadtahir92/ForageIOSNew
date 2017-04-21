//
//  HomeFarmInventoryController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/10/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeFarmInventoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var farmId: String?
    var invArr: [Inventory]?
    @IBOutlet weak var tableView: UITableView!
    
    private func updateCellQty(cell: UITableViewCell, qty: Double, directEdit: Bool) {
    
        if let indexPath = self.tableView.indexPath(for: cell) {
            let row = indexPath.row
            let inv = invArr![row]
            let count = ParseHomeOwner.updateInventoryToHome(inv: inv, count: qty, directEdit: directEdit)
            
            if let cell = cell as? HomeFarmInventoryCell {
                // If the cell is still visible!!!
                cell.inventoryQty.text = Formatter.formatQty(qty: count)
                if (qty < inv.totalAvailable) {
                    cell.inventoryQty.textColor = UIColor.green
                } else {
                    cell.inventoryQty.textColor = UIColor.red
                }
            }
        }
    }
    
    @IBAction func qtyIncreased(_ sender: UIButton) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            updateCellQty(cell: cell, qty: 1, directEdit: false)
        }
    }
    
    @IBAction func qtyDecreased(_ sender: UIButton) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            updateCellQty(cell: cell, qty: -1, directEdit: false)
        }
    }
    
    @IBAction func qtyChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if let qVal =  Double(sender.text!) {
                updateCellQty(cell: cell, qty: qVal, directEdit: true)
            } else {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? HomeFarmInventoryCell {
                    cell.inventoryQty.text = Formatter.formatQty(qty: 0)
                    cell.inventoryQty.textColor = UIColor.red
                }
            }
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let invArr = invArr {
            return invArr.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.homeFarmInventory", for: indexPath) as! HomeFarmInventoryCell
        
        let inv = invArr![indexPath.row]
        cell.setup(inv: inv)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getInventories()
    }
    
    func getInventories() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseFarmer.findFarmsInventory(farmId: farmId!, completionHandler: { (invList : [Inventory]) -> Void in
        
            self.invArr = invList
            self.tableView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
