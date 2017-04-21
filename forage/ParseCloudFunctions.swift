//
//  ParseCloudFunctions.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/3/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse.PFCloud

class ParseCloudFunctions: PFQuery<PFObject> {
    
    /*
     * Get the customer record from Stripe!
     */
    static func getStripeCustomer(completionHandler: @escaping (_ customer: Any?, _ error: Error?) -> Void) {
        
        let hRecord = Globals.globObj.homeRecord! // unwrap it!
        
        let params: [AnyHashable: Any] =
            [AnyHashable(Constants.CUST_ID_STR): hRecord.stripeCustomerId!]
        
        // Charge the user!
        PFCloud.callFunction(inBackground: "getStripeCustomer", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error == nil) {
                    completionHandler(result, nil)
                } else {
                    NSLog(Constants.PARSE_CLOUD_ERR, "Response Exception: ", error!.localizedDescription)
                    completionHandler(nil, error)
                }
        })
    }
    
    /*
     * Add a payment type for the customer
     */
    static func setStripeCustomerSource(source: String, completionHandler: @escaping (Error?) -> Void) {
        
        let hRecord = Globals.globObj.homeRecord! // unwrap it!
        
        let params: [AnyHashable: Any] =
            [AnyHashable(Constants.CUST_ID_STR): hRecord.stripeCustomerId!,
             AnyHashable(Constants.CARD_TOKEN_STR): source]
        
        // Charge the user!
        PFCloud.callFunction(inBackground: "setStripeCustomerSource", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error == nil) {
                    completionHandler(nil)
                } else {
                    NSLog(Constants.PARSE_CLOUD_ERR, "Response Exception: ", error!.localizedDescription)
                    completionHandler(error)
                }
        })
    }
    
    
    /*
     * Create a fixed stripe customer upfront!
     */
    static func createStripeCustomer(user: User) -> Void {
    
        // Set up only for home users!
        let uType = user.userType
        if (uType != UserType.HOMEOWNER_USER) {
            return
        }
    
        let params: [AnyHashable: String] =
            [AnyHashable(Constants.USER_EMAIL): user.email!,
             AnyHashable(Constants.HOME_ID): user.homeId!]
    
        // Create a stripe customer for the user!
        PFCloud.callFunction(inBackground: "createStripeCustomer", withParameters: params, block:
            { (respId: Any?, error: Error?) -> Void in
                if (error == nil) {
                    ParseHomeOwner.updateStripeCustomerId(customerId: respId as! String);
                } else {
                    // TODO - XXX - PAYMENT_ERR: Mouli - look at how to handle this one????
                    // Track the failures in the user/home object - so we have a history of what happend and we can recosntruct it!
                    NSLog(Constants.PARSE_CLOUD_ERR, "This is not good Exception: ", error!.localizedDescription)
                }
        })
    }
    
    
    /*
     * Select the payment type for the customer
     */
    static func updateStripeCustomerDefaultSource(source: String, completionHandler: @escaping (Error?) -> Void) {
        
        let hRecord = Globals.globObj.homeRecord! // unwrap it!
        
        let params: [AnyHashable: Any] =
            [AnyHashable(Constants.CUST_ID_STR): hRecord.stripeCustomerId!,
             AnyHashable(Constants.CARD_ID_STR): source]
        
        // Charge the user!
        PFCloud.callFunction(inBackground: "updateStripeCustomerDefaultSource", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error == nil) {
                    completionHandler(nil)
                } else {
                    NSLog(Constants.PARSE_CLOUD_ERR, "Response Exception: ", error!.localizedDescription)
                    completionHandler(error)
                }
        })
    }
    
    /*
     * Charge the card and purchase the inventory!
     */
    static func chargeCard(chargeId : String, completionHandler: @escaping (Error?) -> Void) {
    
        let hRecord = Globals.globObj.homeRecord! // unwrap it!
        let cOrder = hRecord.currentOrder! // unwrap! - we must have an order present!
        
        let params: [AnyHashable: Any] =
            [AnyHashable(Constants.ORDER_ID_STR): cOrder.getOrderId(),
             AnyHashable(Constants.CUST_ID_STR): hRecord.stripeCustomerId!,
             AnyHashable(Constants.CARD_ID_STR): chargeId,
             AnyHashable(Constants.NEW_CARD_STR): false, // We already have the cardId from the token in a prior step!
        ]
        
        // Charge the user!
        PFCloud.callFunction(inBackground: "purchaseInventory", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error == nil) {
                    // Set up our internal records
                    ParseHomeOwner.orderPostProcess()
                    
                    // Invoke payment completion!
                    completionHandler(nil)
                } else {
                    NSLog(Constants.PARSE_CLOUD_ERR, "Response Exception: ", error!.localizedDescription)
                    completionHandler(error)
                }
        })
    }
    

    /*
     * Send the code to the user's email
     * and have them put it back to verify email correctness!
     */
    static func verifyEmail(user: User) {
        
        let params: [AnyHashable: Any] =
            [AnyHashable("userEmail"): user.email!,
             AnyHashable("userCode"): user.objectId!
            ]
        
        // Send an email to the user to verify the registered email-id!
        PFCloud.callFunction(inBackground: "verifyEmail", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
            if (error == nil) {
                NSLog("Cloud Response", "Email Verification sent: \(result) ")
            } else {
                NSLog("Cloud Response exception: ", error!.localizedDescription)
            }
        })
    }
        
    /**
     * Send the order to InfluxDB for analytics!
     *
     * @param order - post payment!
     */
    static func paidOrderPostForAnalytics(order: Order) {
    
        let params: [AnyHashable: Any] =
            [AnyHashable(Constants.ORDER_ID_STR): order.getOrderId()]
        
        // Send inventory item info to cloud
        PFCloud.callFunction(inBackground: "paidOrderPostForAnalytics", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error != nil) {
                    NSLog("Cloud Response", "Order Analytics Exception: ", error!.localizedDescription)
                }
            })
    }
        
    static func trackingEventPost(type: String, series: String,
                                  fieldList: [String: Any],
                                  taglist: [String: Any],
                                  timeStamp: UInt64,
                                  sb: String?) {
        
        var params: [AnyHashable: Any] =
            ["series": series,
             "type": type,
             "eventTimeStamp": timeStamp
            ]
        
        if (fieldList.count > 0) {
            params["fields"] = fieldList
        }
        
        if (taglist.count > 0) {
            params["tags"] = taglist
        }
        
        if (sb != nil) {
            params["lines"] = sb
        }
        
        PFCloud.callFunction(inBackground: "trackingEventPost", withParameters: params, block:
            { (result: Any?, error: Error?) -> Void in
                if (error != nil) {
                    NSLog("Cloud Response", "Tracking event Exception: ", error!.localizedDescription)
                }
        })
    }
    
    static func farminventorypost(inv: Inventory) {
        
        let farmItemInfo: [AnyHashable: Any] =
            [AnyHashable("itemName"): inv.name,
             AnyHashable("itemDescp"): inv.itemDescription!,
             AnyHashable("itemCategory"): inv.type,
             AnyHashable("itemTotal"): inv.totalAvailable,
             AnyHashable("itemPrice"): inv.rate,
             AnyHashable("farmId"): inv.farmId,
             AnyHashable("farmName"): inv.farmName,
             AnyHashable("itemUnits"): inv.unit,
        ]
        
        // Send inventory item info to cloud
        PFCloud.callFunction(inBackground: "farmItemPost", withParameters: farmItemInfo, block:
            { (result: Any?, error: Error?) -> Void in
                if (error != nil) {
                    NSLog("Cloud Response", "Order Analytics Exception: ", error!.localizedDescription)
                }
        })
    }
}
