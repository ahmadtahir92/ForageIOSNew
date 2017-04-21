//
//  HomeFarmsViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class CacheViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var seasonalCollectionView: UICollectionView!
    @IBOutlet weak var orderBuilderCollectionView: UICollectionView!
    @IBOutlet weak var gourmarkCollectionView: UICollectionView!
    
    var fullSeasonalInvList: [Inventory]?
    var seasonalInvList: [Inventory]?
    var orderList: [Order]?
    var fullGourmarkList: [Gourmark]?
    var gourmarkList: [Gourmark]?
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView) {
            case seasonalCollectionView:
                if let inventories = seasonalInvList {
                    return inventories.count
                }
                break;
            case orderBuilderCollectionView:
                if let orders = orderList {
                    return orders.count
                }
                break;
            case gourmarkCollectionView:
                if let gourmarks = gourmarkList {
                    return gourmarks.count
                }
                break;
            default:
                return 0
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (collectionView) {
            case seasonalCollectionView:
                return getSeasonalListCell(collectionView: collectionView, cellForItemAt: indexPath)
            case orderBuilderCollectionView:
                return getOrderListCell(collectionView: collectionView, cellForItemAt: indexPath)
            case gourmarkCollectionView:
                return getgourmarkListCell(collectionView: collectionView, cellForItemAt: indexPath)
            default:
                // We should not get here!!!!
                print("FCK_ERR: Invalid code location!")
                return getSeasonalListCell(collectionView: collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func getSeasonalListCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.foragelocal.seasonalListCell", for: indexPath) as! SeasonalListCell
        
        let inv = seasonalInvList![indexPath.row]
        
        cell.setup(inv: inv)
        
        return cell
    }
    
    private func getOrderListCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.foragelocal.orderListCell", for: indexPath) as! OrderListCell
        
        let order = orderList![indexPath.row]
        
        cell.setup(order: order)

        return cell
    }
    
    private func getgourmarkListCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.foragelocal.gourmarkCell", for: indexPath) as! GourmarkCell
        
        let gourmark = gourmarkList![indexPath.row]
        
        cell.setup(gourmark: gourmark)
        
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        seasonalCollectionView.dataSource = self
        seasonalCollectionView.delegate = self

        orderBuilderCollectionView.dataSource = self
        orderBuilderCollectionView.delegate = self
        
        gourmarkCollectionView.dataSource = self
        gourmarkCollectionView.delegate = self
        
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        getSeasonalList()
        getOrderList()
        getGourmarkList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSeasonalList() {
        ParseHomeOwner.findSeasonals(completionHandler: {(invArr: [Inventory]) -> Void in
            
            self.seasonalInvList = invArr
            self.seasonalCollectionView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func getOrderList() {
        ParseHomeOwner.findOrders(completionHandler: {(orderArr: [Order]) -> Void in
            
            self.orderList = orderArr
            self.orderBuilderCollectionView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func getGourmarkList() {
        ParseHomeOwner.findGourmarks(completionHandler: {(gourmarkArr: [Gourmark]) -> Void in
            
            self.gourmarkList = gourmarkArr
            self.gourmarkCollectionView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
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
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Cache", image: #imageLiteral(resourceName: "cornucopia_icon"), tag: 1)
        
        self.seasonalInvList = [Inventory]()
        self.orderList = [Order]()
        self.gourmarkList = [Gourmark]()
        self.fullSeasonalInvList = [Inventory]()
        self.fullGourmarkList = [Gourmark]()
    }
}
