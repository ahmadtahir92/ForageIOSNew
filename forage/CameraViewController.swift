//
//  FarmCameraViewController.swift
//  forage
//
//  Created by vamsi valluri on 2/12/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

protocol CameraViewControllerDelegate: class {
    func cameraController(nameVC: CameraViewController, didSaveURL imgURL: URL?, imgName: String?)
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imgURL: URL?
    var imgPath: String?
    var imgName = "FORAGE_1_"
    var imgPresented: UIImage?
    weak var delegate: CameraViewControllerDelegate?

    @IBOutlet weak var itemImage: UIImageView!
    
    // Pick photo from Gallery
    @IBAction func pickPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // Take photo with Camera
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func savePhoto(_ sender: Any) {
        // Save to local directory
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // create image name
        let currentDate = Date().timeIntervalSinceReferenceDate
        imgName += "\(currentDate)"
        imgName += ".jpg"
        
        // Set compression quality of the image
        let compressionQuality = 0.8
        
        // Get the file URL
        let fileURL = documentsDirectoryURL.appendingPathComponent(imgName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try UIImageJPEGRepresentation(itemImage.image!, CGFloat(compressionQuality))!.write(to: fileURL)
                print("Image Added Successfully. Path:", fileURL.path)
                imgPath = fileURL.path
                imgURL = fileURL
            } catch {
                print(error)
            }
        } else {
            print("Image Not Added")
        }
        
        // Call the delegate function of the controller that invoked camera to pass img details
        callCameraDelegate()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            itemImage.contentMode = .scaleToFill
            itemImage.image = pickedImage
            //imgURL = info[UIImagePickerControllerReferenceURL] as? URL
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func callCameraDelegate() {
        // Send back the response
        print(delegate!)
        delegate?.cameraController(nameVC: self, didSaveURL: imgURL, imgName: imgName)
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = imgPresented {
            itemImage.image = img
        } else {
            itemImage.image = #imageLiteral(resourceName: "couple_farmers_market")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelCameraPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
