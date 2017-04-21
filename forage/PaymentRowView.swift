//
//  PaymentRowView.swift
//  forage
//
//
//  Created by Chandramouli Balasubramanian on 2/27/17.
//       - Adapted from Ben's CheckoutRowView (stripe example)
//  Copyright © 2017 Forage Inc. All rights reserved.
//
import UIKit

class PaymentRowView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIButton!
    
    var loading = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.loading {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.detailLabel.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.detailLabel.alpha = 1
                }
            }, completion: nil)
        }
    }
    
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
        
        self.backgroundView.backgroundColor = UIColor.clear // Hide the button!
        self.backgroundView.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        if !tappable {
            self.backgroundView.isUserInteractionEnabled = false
            self.backgroundColor = UITheme.defaultDisabledColor
        }
        
        self.titleLabel.text = title
        self.detailLabel.text = detail
        
        var red: CGFloat = 0
        self.backgroundColor?.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
    }
    
    func didTap() {
        self.onTap()
    }
}
