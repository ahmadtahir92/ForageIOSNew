//
//  CourierOrderDetailViewController.swift
//  forage
//
//  Created by vamsi valluri on 3/16/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos

class CourierOrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var courierId: String?
    var orderId: String?
    var invArr: [HomeInventory]?
    var selectedIndexPath: IndexPath?
    static var eventTracker = EventTracker()
    var refreshControl = UIRefreshControl()
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let invArr = invArr {
            return invArr.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.courierOrderDetailCell", for: indexPath) as! CourierOrderDetailTableViewCell
        let inv = invArr![indexPath.row]
        
        // Populate inventory image
        if let finv = inv.farmInv {
            let image = finv.profile
            S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
                // XXX - Vamsi - check if the cell is still in view before setting the image!!!
                cell.invProfile.image = UIImage(contentsOfFile: imageLoc)
            })
        } else {
            cell.invProfile.image = #imageLiteral(resourceName: "heart_icon")
        }
        
        // Populate inventory Name
        cell.invName.text = inv.name
        
        // Populate inventory rate
        let unitStr: String = "/ " + inv.unit
        cell.invRate.text = String(format:"%.1f", inv.rate) + unitStr
        
        
        // Populate inventory quantity
        let qtyStr: String = "Qty: "
        cell.invQty.text = qtyStr + String(format:"%.1f", inv.homeCount)
        cell.invQty.sizeToFit()
        
        // Populate Order Total
        let totalPrice: Double = inv.homeCount * inv.rate
        cell.invPrice.text = "Total Price: $" + String(format:"%.1f", totalPrice)
        cell.invPrice.sizeToFit()
        
        
        // Populate Order Time
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd/MM/yyyy HH:mm:ss z"
        cell.invTime.text = formatter.string(from: inv.updatedAt!)
        cell.invTime.sizeToFit()
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.courierId = ParseCourier.getCourierRec()?.getCourierId()
        getCourierOrderDetails()
        
        // setup refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        CourierOrderDetailViewController.eventTracker.trackScreenEvent(screenType: (ParseCourier.getCourierRec()?.name)! + Constants.GA_COURIER_ORDER_DETAIL_SCREEN)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getCourierOrderDetails()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getCourierOrderDetails() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Query parse for farm orders
        ParseCourier.findCourierOrderDetailInventory(orderId: orderId!, completionHandler: { (hinvList : [HomeInventory]) -> Void in
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

}
