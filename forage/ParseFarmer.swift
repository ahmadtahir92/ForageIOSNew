//
//  ParseFarmer.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import Parse

class ParseFarmer: PFQuery<Farm> {
    
    
    static func createFarm(name: String, address: String, classification: String,
                           image: String, loc: String, specialty: String) {
        
        let query = PFQuery(className: Farm.parseClassName())
        query.whereKey("farmName", equalTo: name)
        query.whereKey("farmLocation", equalTo: loc)
        
        do {
            let farm = try query.getFirstObject() as? Farm
            if (farm == nil) {
                NSLog("Farm Init Abort",  "createFarm failed: ", name)
                return
            }
        } catch {
            NSLog("Farm Init Abort",  "createFarm failed: ", name)
        }

        let farm = Farm()
        farm.farmAddress = address
        farm.farmClassification = classification
        farm.farmSpecialty = specialty
        farm.farmImage = image
        farm.farmName = name
        farm.farmLocation = loc
        farm.featured = true
        farm.farmInventory = [Inventory]()
        farm.saveInBackground()
        
        // Setup a user for the farm too!
        createFarmUser(farm: farm)
    }
        
    static func createFarmUser(farm: Farm) {
        
        let farmUser = User()
        
        farmUser.farmId = farm.getFarmId()
        farmUser.userType = UserType.FARMER_USER
        
        // Not needed - the folder gets autocreated based on the bucket layout in S3
        //S3Enable.createFarmFolder(fName: farm.name, fID: farm.getFarmId())
        
        let farmName = farm.farmName
        farmUser.name = farmName
        
        let email = Formatter.stripName(inputName: farmName) + Constants.LOGIN_DOMAIN
        farmUser.email = email
        farmUser.username = email
        farmUser.password = Constants.LOGIN_DEFAULT_PASSWORD
        farmUser.emailVerified = true
        
        farmUser.address = farm.farmAddress
        
        
        //Inline signup!
        do {
            try farmUser.signUp()
        } catch {
            NSLog("PARSE_ERR - farmer sign up failed", error.localizedDescription)
        }
        
        // Inline save
        do {
            try farmUser.save()
        } catch {
            NSLog("PARSE_ERR - farmer save failed", error.localizedDescription)
        }
    }
    
    /**
     * API to add a new item to the farm's inventory list
     */
    static func saveInventory(newInv: Inventory) {
        let farm = getFarmRec()
        newInv.saveInBackground(block: {(success: Bool, error: Error?) -> Void in
            if (error == nil) {
                /*
                 * DO NOT add an object to a relation until it is fully saved!!!
                 */
                farm.addToFarmInventory(inv: newInv)
                farm.saveInBackground()
            } else {
                NSLog("PARSE_ERR", "Could not save new inventory record!", error!.localizedDescription)
            }
        })
    }
        
    static func deleteInventory(inv: Inventory) {
        let farm = getFarmRec()
        farm.removeFromFarmInventory(inv: inv)
        farm.saveInBackground()
        inv.deleteInBackground()
    }
        
    /*
     * Differs from delete in the sense that
     *     - it is not blown away
     *     - it exists there and can be activated again?
     */
    static func deactivateInventory(inv: Inventory) {
        let farm = getFarmRec()
        farm.removeFromFarmInventory(inv: inv)
        farm.saveInBackground()
    }
        
    static func undoInventoryDelete(inv: Inventory) {
        self.saveInventory(newInv: inv)
    }

    
    /**
     * API to fetch all inventory for a given Farm
     */
    static func findFarmsInventory(farmId: String,  completionHandler: @escaping ([Inventory]) -> Void) {
        
        var invArr = [Inventory]()
        
        let query = PFQuery(className: Farm.parseClassName())
        query.whereKey("objectId", equalTo: farmId)
        query.includeKey("farmInventory")
        query.getFirstObjectInBackground(block: {(farm: PFObject?, error: Error?) -> Void in
            if error == nil {
                let farmInvArr = (farm as! Farm).farmInventory
                let n = farmInvArr.count
                for i in 0..<n {
                    /*
                     * Return LIFO order!
                     * Why - Just like that! :)
                     * Seriously - I like to look at things in the order I create them.
                     */
                    let inv = farmInvArr[n - i - 1]
                    if (inv.totalAvailable > 0) {
                        // If zero - skip showing it!
                        invArr.append(inv)
                    }
                }
                completionHandler(invArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }
    
    /**
     * API to fetch all Orders for a given Farm
     */
    static func findFarmsOrders(farmId: String,  completionHandler: @escaping ([FarmOrder]) -> Void) {
        
        var forderArr = [FarmOrder]()
        
        let query = PFQuery(className: FarmOrder.parseClassName())
        query.whereKey("farmId", equalTo: farmId)
        query.includeKey("userOrder")
        
        // Order by updated time
        query.order(byDescending: "_updated_at")
        
        // Get the timestamp for last 7 days which is 604800 seconds
        let timeStamp = NSDate(timeIntervalSinceNow: -604800)
        query.whereKey("createdAt", greaterThanOrEqualTo: timeStamp)
        
        // Run the query
        query.findObjectsInBackground(block: {
            (odrList: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for order in odrList! {
                    let forder = order as! FarmOrder
                    if (forder.farmTotalPrice == 0.0) {
                        NSLog("Error: Order total is 0")
                    } else {
                        forderArr.append(forder)
                    }
                }
                completionHandler(forderArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })

    }

    /**
     * API to fetch all inventory for a given Farm
     */
    static func findFarmsOrderDetailInventory(farmId: String, farmOrderId: String, completionHandler: @escaping ([HomeInventory]) -> Void) {
        
        var invArr = [HomeInventory]()
        
        let query = PFQuery(className: FarmOrder.parseClassName())
        query.whereKey("objectId", equalTo: farmOrderId)
        query.includeKey("userOrder")
        query.includeKey("homeInventories")
        query.includeKey("homeInventories.farmInv")
        query.getFirstObjectInBackground(block: {(farmOrder: PFObject?, error: Error?) -> Void in
            if error == nil {
                let orderInvArr = (farmOrder as! FarmOrder).homeInventories
                let n = orderInvArr.count
                for i in 0..<n {
                    let inv = orderInvArr[n - i - 1]
                    invArr.append(inv)
                }
                completionHandler(invArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }
    
    /**
     * API to fetch all inventory for a given Farm - Home Owner's view
     */
    static func searchFarmsInventory(queryStr: String, completionHandler: @escaping ([Inventory]) -> Void) {
        
        var invArr = [Inventory]()
        
        var queryStrList = [String]()
        queryStrList.append(contentsOf: Formatter.extractWords(keywordStr: queryStr))
        
        let query = PFQuery(className: Inventory.parseClassName())
        query.whereKey("keywords", containsAllObjectsIn: queryStrList)
        query.findObjectsInBackground(block: {
            (invList: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for inventory in invList! {
                    if let inv = inventory as? Inventory {
                        if (inv.totalAvailable > 0) {
                            // If zero - skip showing it!
                            invArr.append(inv)
                        }
                    }
                }
                completionHandler(invArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }

    /**
     * API to search the farm collection based on a query string!
     */
    static func searchFarms(queryStr: String, completionHandler: @escaping ([Farm]) -> Void) {
    
        var farmArr = [Farm]()
        var queryStrList = [String]()
        
        queryStrList.append(contentsOf: Formatter.extractWords(keywordStr: queryStr))
        let query = PFQuery(className: Farm.parseClassName())
        query.whereKey("featured", equalTo: true)
        query.whereKey("invComplete", equalTo: true)
        query.whereKey("keywords", containsAllObjectsIn: queryStrList)
        query.findObjectsInBackground(block: {
            (farmList: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for farm in farmList! {
                    farmArr.append(farm as! Farm)
                }
                completionHandler(farmArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }
    
    
    /*
     * API to update and store a local copy of the current farm details
     */
    static func setFarmRecord(farmId: String) -> Bool {
        
        let query = PFQuery(className: Farm.parseClassName())
        query.whereKey("objectId", equalTo: farmId)
        query.includeKey("farmInventory")

        /*
         * Do this operation inline
         * This is heavy - but is a one time request!!!
         */
        do {
            let farmRecord = try query.getFirstObject() as! Farm
            
            // Save the farm record locally!
            Globals.globObj.farmRecord = farmRecord
    
            // All set - fire away!
            return true;
        } catch {
            // Log details of the failure
            NSLog("PARSE_ERR: \(error) \(error._userInfo)", "Could not save Farm Record during init!")
            // Bail out!
            return false;
        }
    }
        
    /*
     * Get the farm record from the Glob!
     */
    static func getFarmRec() -> Farm {
        return Globals.globObj.farmRecord!
    }
}
