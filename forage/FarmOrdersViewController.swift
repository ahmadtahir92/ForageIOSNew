//
//  FarmOrdersViewController.swift
//  forage
//
//  Created by vamsi valluri on 3/13/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos

class FarmOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var farmId: String?
    var orderArr: [FarmOrder]?
    var selectedIndexPath: IndexPath?
    var imgSelected: UIImageView? = nil
    static var eventTracker = EventTracker()
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderArr = orderArr {
            return orderArr.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.farmOrderListCell", for: indexPath) as! FarmOrdersTableViewCell
        let farmOrder = orderArr![indexPath.row]
        
        // Populate order image
        cell.orderProfile.image = #imageLiteral(resourceName: "empty_cart")


        // Populate Order Id
        let orderStr: String = "Order: "
        if let orderId = farmOrder.userOrderId {
            cell.orderNumber.text = orderStr + orderId
        } else {
            cell.orderNumber.text = orderStr
        }
        cell.orderNumber.sizeToFit()
        
        // Populate Order Total
        if let totalPrice = farmOrder.farmTotalPrice {
            cell.orderTotal.text = "Total Price: $" + String(format:"%.1f", totalPrice)
            cell.orderTotal.sizeToFit()
        } else {
            cell.orderTotal.text = "Total Price: $"
        }
        
        // Populate Order Time
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd/MM/yyyy HH:mm:ss z"
        cell.orderTime.text = formatter.string(from: farmOrder.updatedAt!)
        cell.orderTotal.sizeToFit()
        
        // Populate Order Customer Name
        let order = farmOrder.userOrder
        if order != nil {
            cell.userName.text = order?.homeName
        } else {
            cell.userName.text = ""
        }
        
        // Invoke order detail when tapped on image
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
//        cell.orderProfile?.addGestureRecognizer(tapGestureRecognizer)
//        cell.orderProfile?.isUserInteractionEnabled = true
//        cell.orderProfile?.tag = indexPath.row
        
        return cell
    }
    
//    //func imageTapped(cell: FarmInventoryCell, sender: UITapGestureRecognizer) {
//    func imageTapped(sender: UITapGestureRecognizer) {
//        let indexPath = IndexPath(item: (sender.view?.tag)! , section: 0)
//        imgSelected = nil
//        if let cell = tableView.cellForRow(at: indexPath) {
//            imgSelected = sender.view as? UIImageView
//            self.performSegue(withIdentifier: "farmItemOrderDetailSegue", sender: cell)
//        }
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.farmId = ParseFarmer.getFarmRec().getFarmId()
        getFarmOrders()
        
        // setup refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        FarmInventoryViewController.eventTracker.trackScreenEvent(screenType: ParseFarmer.getFarmRec().farmName + Constants.GA_FARM_ORDER_LIST_SCREEN)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getFarmOrders()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getFarmOrders() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Query parse for farm orders
        ParseFarmer.findFarmsOrders(farmId: farmId!, completionHandler: { (orderList : [FarmOrder]) -> Void in
            self.orderArr = orderList
            self.tableView.reloadData()
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prep before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var farmId = ""
        var farmOrderId = ""
        
        if let cell = sender as? FarmOrdersTableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let farmOrder = orderArr?[indexPath!.row]
            // Get the farm id and order id for details
            farmId = (farmOrder?.farmId)!
            farmOrderId = (farmOrder?.getFarmOrderId())!
            // Set the data in the destination farm order detail controller
            let farmOrderDetailController = segue.destination as! FarmOrderDetailViewController
            farmOrderDetailController.farmId = farmId
            farmOrderDetailController.farmOrderId = farmOrderId
        }
    }
    

}
