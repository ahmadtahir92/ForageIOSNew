//
//  HomeFarmsViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase

class HomeFarmsViewController: ForageSearchContainer, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dictionaryView: UITableView!
    
    var farmArr: [Farm]
    var eventTracker = EventTracker()
    
    /**
     * Use two columns per row! - some sizing math here. :(
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        return CGSize(width: dimensions, height: dimensions)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.farmArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.foragelocal.homeFarmCell", for: indexPath) as! HomeFarmViewCell
        let farm = farmArr[indexPath.row]
        
        cell.setup(farm: farm)
        return cell
    }
    
    
    func getFarms() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseHomeOwner.findAllFarms(completionHandler: { (farmList : [Farm]) -> Void in
            
            self.farmArr = farmList
            for farm in farmList {
                Globals.addToSearchDictionary(word: farm.farmName)
            }
            
            self.collectionView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    
    override func updateSearchResults(for searchController: UISearchController) {
        if (!searchController.isActive) {
            // Search was cancelled! Do this check first!
            self.view.bringSubview(toFront: collectionView)
            collectionView.alpha = Constants.VIEW_BRIGHT_ALPHA
            dictionaryView.alpha = Constants.VIEW_DIM_ALPHA // Reset alphas
            return
        }
        
        if let searchText = searchController.searchBar.text {
            if (searchText.isEmpty) {
                // Dim the selection
                self.view.bringSubview(toFront: dictionaryView)
                collectionView.alpha = Constants.VIEW_DIM_ALPHA
                dictionaryView.alpha = Constants.VIEW_MEDIUM_ALPHA // so we can see the underneath screen?
                // do not dim the table view which is presented as help for search text
                searchController.dimsBackgroundDuringPresentation = false
                return
            }
            
            self.dictionary = [String]()
            for word in Globals.globObj.searchDictionary {
                if (word.contains(find: searchText)) {
                    self.dictionary.append(word)
                }
            }
            
            self.dictionaryView.reloadData()
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        dictionaryView.dataSource = self
        dictionaryView.delegate = self
        
        getFarms()
        
        eventTracker.trackScreenEvent(screenType: Constants.GA_MAIN_ACTIVITY_SCREEN)
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
        
        if let cell = sender as? HomeFarmViewCell {
            let indexPath = collectionView.indexPath(for: cell)
            let farm = farmArr[indexPath!.row]
            farmId = farm.getFarmId()
        } else {
            farmId = sender as! String
        }
     
        let farmInventoryController = segue.destination as! HomeFarmInventoryController
     
        farmInventoryController.farmId = farmId
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // Init the vars
        self.farmArr = [Farm]()
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Market", image: #imageLiteral(resourceName: "farmers_market_icon"), tag: 0)
        
        // FCM message init
        self.fcmSubscribe()
        self.fcmRegisterToken()
    }
    
    func fcmSubscribe() {
        FIRMessaging.messaging().subscribe(toTopic: Constants.SUBSCRIBE_ORDER_NOTIF_TOPIC)
        print("Subscribed to order notify topic")
    }
    
    func fcmRegisterToken() {
        let token = FIRInstanceID.instanceID().token()
        print("FCM Messaging InstanceID token: \(token!)")
        
        let hRecord = Globals.globObj.homeRecord!
        ParseHomeOwner.updateUserInsightsWithRegToken(hRec: hRecord, token: token)
    }
}
