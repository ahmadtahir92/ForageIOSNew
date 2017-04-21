//
//  FarmOrderDetailViewController.swift
//  forage
//
//  Created by vamsi valluri on 3/15/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos

class FarmOrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var farmId: String?
    var farmOrderId: String?
    var invArr: [HomeInventory]?
    var selectedIndexPath: IndexPath?
    static var eventTracker = EventTracker()
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let invArr = invArr {
            return invArr.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.farmOrderDetailCell", for: indexPath) as! FarmOrderDetailTableViewCell
        let inv = invArr![indexPath.row]
        
        // Populate inventory image
        if let finv = inv.farmInv {
            let image = finv.profile
            S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
                // XXX - Vamsi - check if the cell is still in view before setting the image!!!
                cell.orderDetailProfile.image = UIImage(contentsOfFile: imageLoc)
            })
        } else {
            cell.orderDetailProfile.image = #imageLiteral(resourceName: "heart_icon")
        }
        
        // Populate inventory Name
        cell.invName.text = inv.name
        
        // Populate inventory rate
        let unitStr: String = "/ " + inv.unit
        cell.orderRate.text = String(format:"%.1f", inv.rate) + unitStr

        
        // Populate inventory quantity
        let qtyStr: String = "Qty: "
        cell.orderQty.text = qtyStr + String(format:"%.1f", inv.homeCount)
        cell.orderQty.sizeToFit()
        
        // Populate Order Total
        let totalPrice: Double = inv.homeCount * inv.rate
        cell.totalPrice.text = "Total Price: $" + String(format:"%.1f", totalPrice)
        cell.totalPrice.sizeToFit()
        
        
        // Populate Order Time
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd/MM/yyyy HH:mm:ss z"
        cell.orderTime.text = formatter.string(from: inv.updatedAt!)
        cell.orderTime.sizeToFit()
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.farmId = ParseFarmer.getFarmRec().getFarmId()
        getFarmOrderDetails()
        
        // setup refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        FarmInventoryViewController.eventTracker.trackScreenEvent(screenType: ParseFarmer.getFarmRec().farmName + Constants.GA_FARM_ORDER_DETAIL_SCREEN)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getFarmOrderDetails()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getFarmOrderDetails() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Query parse for farm orders
        ParseFarmer.findFarmsOrderDetailInventory(farmId: farmId!, farmOrderId: farmOrderId!, completionHandler: { (hinvList : [HomeInventory]) -> Void in
            self.invArr = hinvList
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
