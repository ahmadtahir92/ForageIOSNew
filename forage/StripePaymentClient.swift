//
//  BackendAPIAdapter.swift
//  Forage
//
//  Created by Chandramouli Balasubramanian on 2/21/17.
//  Copyright © 2017 Forage. All rights reserved.
//
import Foundation
import Stripe

class StripePaymentClient: NSObject, STPBackendAPIAdapter {
    
    static let sharedClient = StripePaymentClient()
    
    override init() {
        super.init()
    }
        
    @objc func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        // Call the STPCustomerCompletionBlock within our callback handler!
        ParseCloudFunctions.getStripeCustomer(completionHandler: { (customer: Any?, error: Error?) ->  Void in
            
            if let error = error {
                completion(nil, error)
            } else {
                // We already have the json object from Stripe in cloud - directly use it!
                let deserializer = STPCustomerDeserializer(jsonResponse: customer!)
                if let customer = deserializer.customer {
                    completion(customer, nil)
                }
            }
        })
    }
    
    @objc func attachSource(toCustomer source: STPSource, completion: @escaping STPErrorBlock) {
        // Call the STPErrorBlock within our callback handler!
        ParseCloudFunctions.setStripeCustomerSource(source: source.stripeID, completionHandler: completion)
    }
    
    @objc func selectDefaultCustomerSource(_ source: STPSource, completion: @escaping STPErrorBlock) {
        // Call the STPErrorBlock within our callback handler!
        ParseCloudFunctions.updateStripeCustomerDefaultSource(source: source.stripeID, completionHandler: completion)
    }

    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {
        // Call the STPErrorBlock within our callback handler!
        ParseCloudFunctions.chargeCard(chargeId: result.source.stripeID, completionHandler: completion)
    }
}
