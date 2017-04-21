//
//  FarmNewItemViewController.swift
//  forage
//
//  Created by cchannap on 2/19/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Toast_Swift

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = MyPickerView(pickerData: data, dropdownField: self)
    }
}

class FarmNewItemViewController: UIViewController, CameraViewControllerDelegate {
    @IBOutlet weak var gallery_view: UIView!

    @IBOutlet weak var camera_view: UIView!
    @IBOutlet weak var prodName: UITextField!
    @IBOutlet weak var prodDesc: UITextField!
    @IBOutlet weak var prodCategory: UITextField!
    @IBOutlet weak var prodTotalAvailable: UITextField!
    @IBOutlet weak var prodPrice: UITextField!
    @IBOutlet weak var prodUnit: UITextField!
    
    @IBOutlet weak var farmName: UILabel!
    
    @IBOutlet weak var prodProfile: UIButton!
    @IBOutlet weak var seasonalCheckBox: UIButton!
    
    let inv = Inventory()
    var imageName: String = ""
    var imageUrl: URL!
    var categories = ["Vegetables", "Fruits", "Dairy", "Meat", "Flowers"]
    var units = ["lb", "kg", "bunch"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        inv.seasonal = false
        farmName.text = ParseFarmer.getFarmRec().farmName
        
        camera_view.layer.cornerRadius = 50;
        camera_view.clipsToBounds = true;
        camera_view.layer.borderWidth = 1.5;
        camera_view.layer.borderColor = UIColor.white.cgColor;
        
        
        gallery_view.layer.cornerRadius = 50;
        gallery_view.clipsToBounds = true;
        gallery_view.layer.borderWidth = 1.5;
        gallery_view.layer.borderColor = UIColor.white.cgColor;
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func categoryClicked(_ sender: Any) {
        prodCategory.loadDropdownData(data: categories)
    }
    
    @IBAction func unitClicked(_ sender: Any) {
        prodUnit.loadDropdownData(data: units)
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        if prodName.text?.isEmpty ?? true {
            self.view.makeToast("Enter Name")
            return
        } else {
            inv.name = prodName.text!
        }
        
        if prodDesc.text?.isEmpty ?? true {
            self.view.makeToast("Enter Description")
            return
        } else {
            inv.itemDescription = prodDesc.text!
        }
        
        if prodCategory.text?.isEmpty ?? true {
            self.view.makeToast("Enter Category")
            return
        } else {
            inv.type = prodCategory.text!
        }
        
        if prodTotalAvailable.text?.isEmpty ?? true {
            self.view.makeToast("Enter Total available")
            return
        } else {
            inv.totalAvailable = Double(prodTotalAvailable.text!)!
        }
        
        if prodPrice.text?.isEmpty ?? true {
            self.view.makeToast("Enter Price")
            return
        } else {
            inv.rate = Double(prodPrice.text!)!
        }
        
        if prodUnit.text?.isEmpty ?? true {
            self.view.makeToast("Enter Units")
            return
        } else {
            inv.unit = prodUnit.text!
        }
        
        inv.seasonal = false
        inv.farmName = farmName.text!
        inv.farmId = ParseFarmer.getFarmRec().getFarmId()
        
        if imageName.isEmpty || imageUrl == nil {
            self.view.makeToast("choose an image")
            return
        } else {
            let obj_key = S3Enable.getS3ObjKey(fName: farmName.text!, fID: ParseFarmer.getFarmRec().getFarmId())
            let aws_fileName = S3Enable.getS3Filename(obj_key: obj_key, fileName: imageName, prodName: inv.name)
            S3Enable.uploadInventoryImageWithUrl(key: aws_fileName, fileURL: imageUrl)
            inv.profile = aws_fileName
        }
        ParseFarmer.saveInventory(newInv: inv)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func clearNewItemForm(_ sender: Any) {
        prodName.text = ""
        prodDesc.text = ""
        prodCategory.text = ""
        prodTotalAvailable.text = ""
        prodPrice.text = ""
        prodUnit.text = ""
        if (inv.seasonal == true) {
            seasonalCheckBox.setBackgroundImage(UIImage(named: "unchecked_checkbox"), for: .normal)
            inv.seasonal = false
        }
    }
    
    
    @IBAction func cancelNewItemForm(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seasonalCheckBoxClicked(_ sender: Any) {
        if inv.seasonal == false {
            seasonalCheckBox.setBackgroundImage(UIImage(named: "checked_checkbox"), for: .normal)
            inv.seasonal = true
        } else {
            seasonalCheckBox.setBackgroundImage(UIImage(named: "unchecked_checkbox"), for: .normal)
            inv.seasonal = false
        }
    }
    
    // Prep before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addNewItemCameraSegue") {
            let cameraViewController = segue.destination as! CameraViewController
            cameraViewController.delegate = self
        }
    }
    
    // Delegate from Camera Controller
    func cameraController(nameVC: CameraViewController, didSaveURL url: URL?, imgName: String?) {
        //if (url != nil && url.path != nil) {
        if url != nil {
            imageName = imgName!
            imageUrl = url
            self.dismiss(animated: true, completion: nil)
            prodProfile.setBackgroundImage(UIImage(contentsOfFile: (url?.path)!), for: UIControlState.normal)
        } else {
            print("Camera did not return a valid url")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
