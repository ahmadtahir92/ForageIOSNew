//
//  ControllerUtils.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 2/12/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

class ControllerUtils: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func findTableCellFromField(sender: Any?) -> UITableViewCell? {
        
        var senderSuper: UIView = sender as! UIView
        while (!senderSuper.isKind(of: UITableViewCell.self)) {
            if (senderSuper.isKind(of: UITableView.self)) {
                // We have hit the table - abort and avoid indiscriminate traversal!
                return nil
            }
            // Traverse the super till we get the cell!!!
            senderSuper = senderSuper.superview!
        }
        return senderSuper as? UITableViewCell
    }
    
    static func findCollectionCellFromField(sender: Any?) -> UICollectionViewCell? {
        
        var senderSuper: UIView = sender as! UIView
        while (!senderSuper.isKind(of: UICollectionViewCell.self)) {
            if (senderSuper.isKind(of: UICollectionView.self)) {
                // We have hit the collection - abort and avoid indiscriminate traversal!
                return nil
            }
            // Traverse the super till we get the cell!!!
            senderSuper = senderSuper.superview!
        }
        return senderSuper as? UICollectionViewCell
    }
}
