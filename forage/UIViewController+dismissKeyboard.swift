//
//  UIViewController+dismissKeyboard.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/12/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
