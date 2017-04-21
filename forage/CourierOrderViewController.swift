//
//  CourierOrderViewController.swift
//  
//
//  Created by vamsi valluri on 3/16/17.
//
//

import UIKit
import MBProgressHUD
import Photos

class CourierOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var courierId: String?
    var orderArr: [Order]?
    var selectedIndexPath: IndexPath?
    var imgSelected: UIImageView? = nil
    static var eventTracker = EventTracker()
    var refreshControl = UIRefreshControl()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orderArr = orderArr {
            return orderArr.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.courierOrderListCell", for: indexPath) as! CourierOrderTableViewCell
        let order = orderArr![indexPath.row]
        
        // Populate order image
        let hinvArr = order.homeInventories
        if (hinvArr.count > 0) {
            let inv = hinvArr[0]
            if let finv = inv.farmInv {
                let image = finv.profile
                S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
                    // XXX - Vamsi - check if the cell is still in view before setting the image!!!
                    cell.orderProfile.image = UIImage(contentsOfFile: imageLoc)
                })
            } else {
                cell.orderProfile.image = #imageLiteral(resourceName: "heart_icon")
            }
        } else {
            cell.orderProfile.image = #imageLiteral(resourceName: "heart_icon")
        }
        
        
        // Populate Order Number
        let orderStr: String = "Order: "
        cell.orderNumber.text = orderStr + order.getOrderId()
        cell.orderNumber.sizeToFit()
        
        // Populate Order Total Price
        let orderTotalStr: String = "Total Price: $"
        cell.orderPrice.text = orderTotalStr + String(format:"%.1f", order.checkoutPrice)
        cell.orderPrice.sizeToFit()

        
        // Populate Order Time
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MM/dd/yyyy HH:mm:ss z"
        if let coTime = order.checkoutTime {
            cell.orderTime.text = formatter.string(from: coTime)
            cell.orderTime.sizeToFit()
        }
        
        // Populate Order Customer Name
        cell.orderName.text = order.getOrderName()
        cell.orderName.sizeToFit()

        // Populate Order Address
        cell.orderAddress.text = order.homeAddress
        
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
        
        self.courierId = ParseCourier.getCourierRec()?.getCourierId()
        getCourierOrders()
        
        // setup refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        CourierOrderViewController.eventTracker.trackScreenEvent(screenType: (ParseCourier.getCourierRec()?.name)! + Constants.GA_COURIER_ORDER_LIST_SCREEN)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getCourierOrders()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getCourierOrders() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Query parse for courier orders
        ParseCourier.findCourierOrders(courierId: courierId!, completionHandler: { (orderList : [Order]) -> Void in
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
        var orderId = ""
        
        if let cell = sender as? CourierOrderTableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let order = orderArr?[indexPath!.row]
            // Get the farm id and order id for details
            orderId = (order?.getOrderId())!
            // Set the data in the destination farm order detail controller
            let courierOrderDetailController = segue.destination as! CourierOrderDetailViewController
            courierOrderDetailController.orderId = orderId
        }
    }

}
