//
//  ParseMisc.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class ParseMisc: PFQuery<PFObject> {
    static var eventTracker = EventTracker()
    
    /* TODO - XXX - dummy functions to populate DB - please remove!!! */
    /* One time function */
    static func setupInventories() {
        
        let query = PFQuery(className: Inventory.parseClassName())
        //query.whereKey("farmName", equalTo: "The Midwife and The Baker")
        query.limit = 1000
        
        query.findObjectsInBackground(block: {
            (invArr: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for inv in invArr! {
                    let inv = inv as! Inventory
                    inv.extractKeywords()
                    do {
                        try inv.save()
                    } catch {
                        NSLog("PARSE_ERR: \(error)", "Could not sae inventory!")
                    }
                }
            } else {
                // Log details of the failure
                NSLog("PARSE_ERR: \(error!) \(error!._userInfo)")
            }
        })
    }
    
    /* One time function */
    static func createInventory(generate: Bool) {
        let farmId = "Cl23NGoEu7"; // Swank Farms
        
        if (!generate) {
            // Just return;
            return;
        }
        
        let query = PFQuery(className: Farm.parseClassName())
        query.whereKey("objectId", equalTo: farmId)
        query.includeKey("farmInventory")
        do {
            let farm = try query.getFirstObject() as! Farm
            let newInv = Inventory()
            newInv.farmId = farmId
            newInv.name = "Raddish"
            newInv.totalAvailable = 3000
            newInv.rate = 1.0
            newInv.type = "vegetable"
            newInv.unit = "bunch"
            newInv.farmName = farm.farmName
            newInv.profile = "radish.jpg"
            newInv.extractKeywords()
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
        } catch {
            NSLog("PARSE_ERR: \(error) \(error._userInfo)")
        }
    }
    
    /* One time function */
    static func updateAllFarmUsersEmail() {
        
        let query = PFQuery(className: User.parseClassName())
        // Get all the farms
        query.findObjectsInBackground(block: {
            (userArr: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for user in userArr! {
                    let user = user as! User
                    let email = user.email!
                    user.email = email.lowercased()
                    if (user.isNew) {
                        // new object created this session, simply continue
                        continue
                    }
                    do {
                        try user.save()
                    } catch {
                        NSLog("PARSE_ERR", "Could not update user!", error.localizedDescription)
                    }
                }
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }
    /* TODO - XXX - end of dummy functions to populate DB - please remove!!! */
    
    
    /* One time function */
    static func createGourmark(name: String, profile: String, srcUrl: String, instruction: String,
                             origAuthor: String, shareAuthor: String?, description: String, shared: Bool) {
        
        var sAuthor = shareAuthor
        if sAuthor == nil  {
            // use the current user
            sAuthor = User.getCurrentUser().name
        }
        
        let gourmark = Gourmark(name: name, profile: profile, srcUrl: srcUrl, instructions: instruction, origAuthor: origAuthor, shareAuthor: sAuthor!, description: description, shared: shared)
        gourmark.saveInBackground() // Save it!
    }

        
    static func sendOrdersToAnalytics() {
        let query = PFQuery(className: Order.parseClassName())
        query.findObjectsInBackground(block: {
            (ordArr: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for order in ordArr! {
                    let ord = order as! Order
                    if (ord.checkoutPrice > 0) {
                        ///ParseCloudFunctions.paidOrderPostForAnalytics(ord)
                        eventTracker.trackOrderEvent(order: ord)
                    }
                }
            } else {
                // Log details of the failure
                NSLog("Error: \(error!) \(error!._userInfo)")
            }
        })
    }
    
    
}
