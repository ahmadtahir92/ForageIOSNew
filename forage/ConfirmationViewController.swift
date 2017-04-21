//
//  ConfirmationViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 3/1/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var invTableData: [(String, [String])]
    var totalPriceText = ""
    
    @IBOutlet weak var backtoShopButton: ForageButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backtoShopAction(_ sender: ForageButton) {
        poptoCart()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return invTableData.count
    }
    
    let cellIdentifier = "com.foragelocal.confirmationTableViewCell"
    let headerViewIdentifier = "com.foragelocal.confirmationTableViewHeaderView"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invTableData[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        let inventories = self.invTableData[indexPath.section].1
        cell.textLabel?.text = inventories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier)! as UITableViewHeaderFooterView
        header.textLabel?.text = self.invTableData[section].0
        return header
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        return (self.invTableData[titleForHeaderInSection].0)
    }
    
    public func rowText(hInv: HomeInventory) -> String {
        let inv = hInv.farmInv!
        
        let rowTxt = Constants.DASH_STR + Formatter.formatQty(qty: hInv.homeCount) + Constants.SPACE_STR + inv.unit + Constants.SPACE_STR + inv.name
        
        return rowTxt
    }
    
    private func processInventories(inventories: [HomeInventory]) {
        var fName: String = ""
        
        // Default init to -1
        var sectionCount = -1
        var rowCount = -1
        for i in 0..<inventories.count {
            let hInv = inventories[i]
            let inv = hInv.farmInv!
            
            if (fName != inv.farmName) {
                // new section
                fName = inv.farmName
                
                // bump section counter
                sectionCount += 1
                
                // reset row counter
                rowCount = -1
                
                let defRow = (fName, [String]())
                invTableData.append(defRow)
            }
            // New row - bump up counter
            rowCount += 1
            // Save the home inventory
            invTableData[sectionCount].1.append(rowText(hInv: hInv))
        }
    }
    
    private func setupLabels() {
        /**
         * Remember with order post processing - a successful order will have been assigned to the last order!
         */
        let order = ParseHomeOwner.getHomeLastOrder()!
        
        self.titleLabel.text = Constants.PAYMENT_THANK_YOU_STR
        self.detailLabel.text = Constants.PAYMENT_ORDER_CONFIRMATION_PREFIX_STR + order.getOrderId()
            
        self.dateLabel.text = Formatter.dateToStr(date: order.checkoutTime!)
        self.totalLabel.text = self.totalPriceText
        
        // Sync call - just get the current array list!
        processInventories(inventories: order.homeInventories)
        if (self.invTableData.count == 0) {
            // empty cart
            self.tableView.isHidden = true
        } else {
            // items in cart
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Constants.APP_COMPANY_NAME
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        
        self.backtoShopButton.setup(title: Constants.RETURN_TO_SHOPPING_STR, enabled: true)
        
        // Use this to get rid of empty cells!
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.setupLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func poptoCart() {
        let viewControllers = (self.navigationController?.viewControllers)!
    
        for aViewController in viewControllers {
            if(aViewController is CartViewController){
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // Init the vars
        self.invTableData = [(String, [String])]()
        super.init(coder: aDecoder)
    }
}
