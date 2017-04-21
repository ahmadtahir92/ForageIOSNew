//
//  S3Enable.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/31/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import AWSS3

class S3Enable {
    
    static let S3_DEFAULT_BUCKET = "farmview"
    static let S3_FARMVIEW_INVENTORY_KEY_PREFIX = "inventory"
    static let S3_FARMVIEW_ICONS_IMAGE_BUCKET = "farmview/icons"
    static let S3_FARMVIEW_LOGOS_IMAGE_BUCKET = "farmview/logos"
    // static let S3_FARMVIEW_FARMS_IMAGE_BUCKET = "farmview/farms"
    static let S3_FARMVIEW_FARMS_IMAGE_BUCKET = "farmview/farms_profile"
    static let S3_FARMVIEW_ADMIN_IMAGE_BUCKET = "farmview/admin"
    static let S3_FARMVIEW_GOURMARKS_IMAGE_BUCKET = "farmview/gourmarks"
    static let AWS_USER_POOL_ID = "us-west-2_IakBx4udt"
    static let AWS_IDENTITY_POOL_ID = "us-west-2:781dd272-456e-408d-87da-88ccb1b04435"
    
    class func S3Init() {
        // Set the region of the S3 bucket
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId: AWS_IDENTITY_POOL_ID)
        /**
         * Bhendi: Big gotcha here with AWS regions!
         * ID_POOL in USWest2 - move it to USWest1
         * S3 <farmview> bucket is in USWest1
         * Set service configuration to USWest1
         */
        let configuration =
            AWSServiceConfiguration(region:.USWest1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
        
    static func getS3Filename(obj_key: String, fileName: String, prodName: String) -> String {
        // Object key is the directory hierarchy
        let s3FN = obj_key + Constants.AWS_FOLDER_SUFFIX + Formatter.stripName(inputName: prodName) + Constants.AWS_UNDERSCORE + fileName as String
        return (s3FN)
    }
        
    static func getS3Filename(obj_key: String, fileName: String) -> String {
        // Object key is the directory hierarchy
        //    - if product name not provided - it is manual entry
        let s3FN = obj_key + Constants.AWS_FOLDER_SUFFIX + fileName as String
        return (s3FN)
    }
        
    static func getS3ObjKey(fName: String, fID: String) -> String {
        if (fID == "") {
            return (Formatter.stripName(inputName: fName));
        } else {
            return (Formatter.stripName(inputName: fName) + Constants.AWS_UNDERSCORE + fID);
        }
    }
    
    private static func getInventoryKey(key: String) -> String {
        /**
         * Transfer utility or S3 is bonkers
         * The buckert is only top level.
         * If you have nested folders - prefix them to the key and not in the bucket!
         */
        return (S3_FARMVIEW_INVENTORY_KEY_PREFIX + "/" + key)
    }
    
    static func uploadInventoryImage(key: String, filename: String) {
        
        let inventoryKey = getInventoryKey(key: key)
        
        let fileURL = URL(fileURLWithPath: filename) // The file to upload
        let  transferUtility = AWSS3TransferUtility.default()
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
            // TODO - Mouli Do something e.g. Update a progress bar.
            })
        }
        
        let completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                // TODO - Mouli - Dismiss the progress bar!!!
            })
        } as AWSS3TransferUtilityUploadCompletionHandlerBlock?
        
        transferUtility.uploadFile(fileURL,
                                   bucket: S3_DEFAULT_BUCKET,
                                   key: inventoryKey,
                                   contentType: "image/jpg",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                        print("Hurray!: transfer complete")
                                    }
                                    return nil
        }
    }
    
    static func uploadInventoryImageWithUrl(key: String, fileURL: URL) {
        
        let inventoryKey = getInventoryKey(key: key)
        let  transferUtility = AWSS3TransferUtility.default()
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // TODO - Mouli Do something e.g. Update a progress bar.
            })
        }
        
        let completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                // TODO - Mouli - Dismiss the progress bar!!!
            })
            } as AWSS3TransferUtilityUploadCompletionHandlerBlock?
        
        transferUtility.uploadFile(fileURL,
                                   bucket: S3_DEFAULT_BUCKET,
                                   key: inventoryKey,
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                        print("Hurray!: transfer complete")
                                    }
                                    return nil
        }
    }
    
    static func getS3ImageFromUrl(bucket: String, key: String, imageCB: @escaping (String) -> Void) {
        
        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        let fileURL = downloadingFileURL // The file URL of the download destination
        
        let fileDir = fileURL.deletingLastPathComponent().path
        if (!FileManager.default.fileExists(atPath: fileDir)) {
            do {
            try FileManager.default.createDirectory(atPath: fileDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("file error on device: ", fileURL, error.localizedDescription)
                return
            }
        }

        let completionHandler = { (task, location, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On successful downloads, `location` contains the S3 object file URL.
                // On failed downloads, `error` contains the error object.
                if ((error) != nil) {
                    print("Image download for ", location!, "failed with error:", error!)
                } else if (location == nil) {
                    print("download did not succeed for ", location as Any)
                } else {
                    imageCB((location?.path)!)
                }
            })
        } as AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        
        let  transferUtility = AWSS3TransferUtility.default()
        transferUtility.download(
            to: fileURL,
            bucket: bucket,
            key: key,
            expression: nil,
            completionHandler: completionHandler
            ).continueWith {
                (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                return nil
        }
    }
    
    static func getInventoryImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_DEFAULT_BUCKET, key: getInventoryKey(key: key), imageCB: imageCB)
    }

    static func getIconsImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_FARMVIEW_ICONS_IMAGE_BUCKET, key: key, imageCB: imageCB)
    }
    
    static func getLogosImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_FARMVIEW_LOGOS_IMAGE_BUCKET, key: key, imageCB: imageCB)
    }
    
    static func getFarmsImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_FARMVIEW_FARMS_IMAGE_BUCKET, key: key, imageCB: imageCB)
    }
    
    static func getAdminImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_FARMVIEW_ADMIN_IMAGE_BUCKET, key: key, imageCB: imageCB)
    }
    
    static func getGourmarkImage(key: String, imageCB: @escaping (String) -> Void) {
        return getS3ImageFromUrl(bucket: S3_FARMVIEW_GOURMARKS_IMAGE_BUCKET, key: key, imageCB: imageCB)
    }

    
    /*
     * Should not really be called!!! Blow this away!
     */
    static func createFarmFolder(fName: String, fID: String) {
        // This is not really needed. The first image whn saved, will auto create the folder in AWS!
    }
    
    static func transferUtilityIntercetApp(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

}
