//
//  ParseCourier.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class ParseCourier: PFQuery<Courier> {
    
    /*
     * Create a new courier
     *
     *     - inline save - expensive!
     */
    static func createCourierRecord(user: User) -> Courier? {
        
        let cRec = Courier()
        
        cRec.name = user.name!
        cRec.email = user.email!
        
        // Inline save
        do {
            try cRec.save()
        } catch {
            NSLog("Parse save error", error.localizedDescription)
            return nil
        }
        return cRec;
    }
        
    /*
     * API to update and store a local copy of the current courier details
     */
    static func setCourierRecord(courierId: String) -> Bool {
        
        let query = PFQuery(className: Courier.parseClassName())
        query.whereKey("objectId", equalTo: courierId)
        do {
            let cRec = try query.getFirstObject() as! Courier
            Globals.globObj.courierRecord = cRec
            
            // Ready to go!
            return true
            
        } catch {
            NSLog("Parse save error", error.localizedDescription)
            // Bail out
            return false;
        }
    }
        
    /*
     * Get the courier record from the Glob!
     */
    static func getCourierRec() -> Courier? {
        return Globals.globObj.courierRecord
    }
    
    /**
     * API to fetch all Orders for a given Farm
     */
    static func findCourierOrders(courierId: String,completionHandler: @escaping ([Order]) -> Void) {
        
        var corderArr = [Order]()
        
        let query = PFQuery(className: Order.parseClassName())
        query.includeKey("home")
        query.includeKey("homeInventories")
        query.includeKey("homeInventories.farmInv")
        
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
                    let corder = order as! Order
                    corderArr.append(corder)
                }
                completionHandler(corderArr)
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
        
    }
    
    /**
     * API to fetch all inventory for a given Farm
     */
    static func findCourierOrderDetailInventory(orderId: String, completionHandler: @escaping ([HomeInventory]) -> Void) {
        
        var invArr = [HomeInventory]()
        
        let query = PFQuery(className: Order.parseClassName())
        query.whereKey("objectId", equalTo: orderId)
        query.includeKey("homeInventories")
        query.includeKey("homeInventories.farmInv")
        query.getFirstObjectInBackground(block: {(order: PFObject?, error: Error?) -> Void in
            if error == nil {
                let orderInvArr = (order as! Order).homeInventories
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

}
