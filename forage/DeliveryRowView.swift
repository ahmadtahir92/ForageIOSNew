//
//  DeliveryRow.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import GooglePlaces

class DeliveryRowView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var backgroundView: UIButton!
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var detail: String = "" {
        didSet {
            self.detailLabel.text = detail
        }
    }
    
    var onTap: () -> () = {}
    
    func setup(title: String, detail: String, tappable: Bool = true) {
        self.title = title
        self.detail = detail
        
        self.backgroundColor = UITheme.defaultBackgroundColor
        
        self.backgroundView.backgroundColor = UIColor.clear // Hide the button!
        self.backgroundView.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        if !tappable {
            self.backgroundView.isUserInteractionEnabled = false
            self.backgroundColor = UITheme.defaultDisabledColor
        }
        
        self.titleLabel.text = title
        self.detailLabel.text = detail
    }
    
    func didTap() {
        self.onTap()
    }
    
    static func getDeliveryFee(delivery: Bool) -> Double {
        if (delivery) {
            return Constants.DEFAULT_DELIVERY_COST
        } else {
            return Constants.NO_DELIVERY_COST
        }
    }
}
