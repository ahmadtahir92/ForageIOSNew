//
//  FarmInventoryViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos
import Firebase

class FarmInventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CameraViewControllerDelegate {

    var farmId: String?
    var invArr: [Inventory]?
    var selectedIndexPath: IndexPath?
    var imgSelected: UIImageView? = nil
    static var eventTracker = EventTracker()
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    private func formatQty(qty: Double) -> String {
        return String(format:"%.1f", qty)
    }
    
    private func formatString(str: String) -> String {
        return String(format:"%s", str)
    }
    
    private func findInventoryforCell(cell: UITableViewCell ) -> Inventory? {
        
        var inv = nil as Inventory?
        
        if let indexPath = self.tableView.indexPath(for: cell) {
            let row = indexPath.row
            inv = invArr![row]
        }
        return inv
    }
    
    @IBAction func invPriceChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if let updateVal =  Double(sender.text!) {
                if let inv = findInventoryforCell(cell: cell) {
                    inv.rate = updateVal
                    inv.saveInBackground()
                    FarmInventoryViewController.eventTracker.trackFarmEvent(inv: inv)
                }
            } else {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? FarmInventoryCell {
                    cell.price.text = formatQty(qty: 0)
                    cell.price.textColor = UIColor.red
                }
            }
        }
    }
    
    /**
     * XXXX - Chetan - should be drop down menu     
     */
    @IBAction func invUnitChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if sender.text?.isEmpty ?? true {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? FarmInventoryCell {
                    cell.unit.text = formatString(str: "Err")
                    cell.unit.textColor = UIColor.red
                }
            } else {
                var updateVal = sender.text!
                if let inv = findInventoryforCell(cell: cell) {
                    updateVal.remove(at: updateVal.startIndex)
                    inv.unit = updateVal
                    inv.saveInBackground()
                    FarmInventoryViewController.eventTracker.trackFarmEvent(inv: inv)
                }
                
            }
        }
    }
    
    @IBAction func invNameChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if sender.text?.isEmpty ?? true {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? FarmInventoryCell {
                    cell.inventoryName.text = formatString(str: "Err")
                    cell.inventoryName.textColor = UIColor.red
                }
            } else {
                let updateVal = sender.text!
                if let inv = findInventoryforCell(cell: cell) {
                    inv.name = updateVal
                    inv.saveInBackground()
                }
                
            }
        }
    }
    
    @IBAction func invDescChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if sender.text?.isEmpty ?? true {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? FarmInventoryCell {
                    cell.inventoryDescription.text = formatString(str: "Err")
                    cell.inventoryDescription.textColor = UIColor.red
                }
            } else {
                let updateVal = sender.text!
                if let inv = findInventoryforCell(cell: cell) {
                    inv.itemDescription = updateVal
                    inv.saveInBackground()
                }
                
            }
        }
    }
    
    @IBAction func qtyChanged(_ sender: UITextField) {
        if let cell = ControllerUtils.findTableCellFromField(sender: sender) {
            if let updateVal =  Double(sender.text!) {
                if let inv = findInventoryforCell(cell: cell) {
                    inv.totalAvailable = updateVal
                    inv.saveInBackground()
                    FarmInventoryViewController.eventTracker.trackFarmEvent(inv: inv)
                }
            } else {
                print("FMT_ERR: User did not enter a valid value!")
                if let cell = cell as? FarmInventoryCell {
                    cell.totalAvailable.text = formatQty(qty: 0)
                    cell.totalAvailable.textColor = UIColor.red
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.farmInventory", for: indexPath) as! FarmInventoryCell
        
        let inv = invArr![indexPath.row]
        
        let image = inv.profile
        
        S3Enable.getInventoryImage(key: image, imageCB: { (imageLoc: String) -> Void in
            cell.inventoryProfile.image = UIImage(contentsOfFile: imageLoc)
        })

        
        let title = inv.name
        cell.inventoryName.text = title
        cell.inventoryName.sizeToFit()
        
        /**
         * Add farm Name in the cart!
         */
        // let fName = inv.farmName
        cell.farmName.text = ParseFarmer.getFarmRec().farmName
        cell.farmName.sizeToFit()
        
        if let invDesc = inv.itemDescription {
            cell.inventoryDescription.text = invDesc
            cell.inventoryDescription.sizeToFit()
        } else {
            cell.inventoryDescription.text = ""
            cell.inventoryDescription.sizeToFit()
        }
        
        let price = inv.rate
        cell.price.text = "$" + String(format:"%.1f", price)
        cell.price.sizeToFit()
        
        let unit = inv.unit
        cell.unit.text = "/  " + unit
        cell.unit.sizeToFit()
        
        let avail = inv.totalAvailable
        cell.totalAvailable.text = formatQty(qty: avail)
        // Fixed width - do not resize! - cell.inventoryQty.sizeToFit()
        
        // Invoke camera for pic update when tapped on image
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        cell.inventoryProfile?.addGestureRecognizer(tapGestureRecognizer)
        cell.inventoryProfile?.isUserInteractionEnabled = true
        cell.inventoryProfile?.tag = indexPath.row
        
        return cell
    }
    
    //func imageTapped(cell: FarmInventoryCell, sender: UITapGestureRecognizer) {
    func imageTapped(sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(item: (sender.view?.tag)! , section: 0)
        imgSelected = nil
        if let cell = tableView.cellForRow(at: indexPath) {
            imgSelected = sender.view as? UIImageView
            self.performSegue(withIdentifier: "farmItemCameraSegue", sender: cell)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = ParseFarmer.getFarmRec().farmName
        self.farmId = ParseFarmer.getFarmRec().getFarmId()
        getInventories()
        
        // setup refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
        FarmInventoryViewController.eventTracker.trackScreenEvent(screenType: ParseFarmer.getFarmRec().farmName + Constants.GA_FARM_ACTIVITY_SCREEN)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getInventories()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
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
    
    // Prep before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "farmItemCameraSegue") {
            let cameraViewController = segue.destination as! CameraViewController
            cameraViewController.delegate = self
            let cell = sender as! FarmInventoryCell
            selectedIndexPath = nil
            if let indexPath = tableView.indexPath(for: cell) {
                // Setting the indexpath
                selectedIndexPath = indexPath
            }
            // If this is image update tap, pass the image to camera view controller
            if imgSelected != nil {
                if let img = imgSelected!.image {
                    cameraViewController.imgPresented = img
                } else {
                    cameraViewController.imgPresented = nil
                }
                // Reset for the next tap
               imgSelected = nil
            } else {
                cameraViewController.imgPresented = nil
            }
        }
    }
    
    // Delegate from Camera Controller
    func cameraController(nameVC: CameraViewController, didSaveURL url: URL?, imgName: String?) {
        // Get the cell
        if let idxPath = selectedIndexPath {
            if let imgUrl = url {
                // Get the inventory
                let inv = invArr![idxPath.row]
                // Get S3 AWS filename and upload new image
                let image = inv.profile
                S3Enable.uploadInventoryImageWithUrl(key: image, fileURL: imgUrl)
                // Save inventory changes
                inv.saveInBackground()
                // Update the cell
                let cell = self.tableView.cellForRow(at: idxPath) as! FarmInventoryCell
                cell.inventoryProfile.image = UIImage(contentsOfFile: (url?.path)!)
            }
            // Reset the selected indexpath
            selectedIndexPath = nil
        } else {
            print("FMT_ERR: Camera call back did not return a valid selected index path!")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    required init?(coder aDecoder: NSCoder) {
        
        // Init the vars
        self.invArr = [Inventory]()
        super.init(coder: aDecoder)
        
        // FCM message init
        self.fcmSubscribe()
        self.fcmRegisterToken()
    }
    
    func fcmSubscribe() {
        FIRMessaging.messaging().subscribe(toTopic: Constants.SUBSCRIBE_INVENTORY_UPDATE_NOTIF_TOPIC)
        print("Subscribed to Farm Inventory Update topic")
    }
    
    func fcmRegisterToken() {
        let token = FIRInstanceID.instanceID().token()
        print("FCM Messaging InstanceID token: \(token!)")
        // TODO: Update Farm User Metadata with token
    }

}



