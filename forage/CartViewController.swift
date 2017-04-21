//
//  CartViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyCart: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: ForageButton!
    
    var invArr: [HomeInventory]
    
    var price: Double = 0.0
    var shipAddr: String = ""
    
    private func updateCellQty(cell: UITableViewCell, qty: Double, directEdit: Bool) {
        
        if let indexPath = self.tableView.indexPath(for: cell) {
            let row = indexPath.row
            let hInv = invArr[row]
            let count = ParseHomeOwner.updateInventoryToHome(homeInv: hInv, count: qty, directEdit: directEdit)
            
            if let cell = cell as? HomeInventoryCell {
                let inv = hInv.farmInv!
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

    @IBAction func qtyChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if let qVal =  Double(sender.text!) {
                updateCellQty(cell: cell, qty: qVal, directEdit: true)
            } else {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? HomeInventoryCell {
                    cell.inventoryQty.text = Formatter.formatQty(qty: 0)
                    cell.inventoryQty.textColor = UIColor.red
                }
            }
        }
    }

    @IBAction func qtyDecreased(_ sender: UIButton) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            updateCellQty(cell: cell, qty: -1, directEdit: false)
        }
    }
    
    @IBAction func qtyIncreased(_ sender: UIButton) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            updateCellQty(cell: cell, qty: 1, directEdit: false)
        }
    }
    
    @IBAction func checkoutCart(_ sender: UIButton) {
        
        ParseHomeOwner.updateOrderTimestamp()
        
        // Set the price to be validated!!!
        self.price = ParseHomeOwner.updateCartCheckoutPrice()
        
        let hRecord = Globals.globObj.homeRecord!
        self.shipAddr = hRecord.address!
        
        if (self.price <= 0) {
            let alertController = UIAlertController(title: "Err...", message: "Basket cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.homeInventory", for: indexPath) as! HomeInventoryCell
        
        let hInv = invArr[indexPath.row]
        cell.setup(hInv: hInv)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.checkoutButton.setup(title: "Checkout", enabled: true)
        
        self.emptyCart.image = #imageLiteral(resourceName: "empty_basket")
        self.tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sync call - just get the current array list!
        self.invArr = ParseHomeOwner.findHomesInventory()
        if (self.invArr.count == 0) {
            // empty cart
            self.tableView.isHidden = true
        } else {
            // items in cart
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // Init the vars
        self.invArr = [HomeInventory]()
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Tote", image: #imageLiteral(resourceName: "orch_cart_icon"), tag: 3)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let checkoutViewController = segue.destination as! CheckoutViewController
        checkoutViewController.setup(price: self.price, shipAddress: shipAddr)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueToCheckout" {
            if (self.price <= 0) {
                return false
            }
        }
        return true
    }
}
