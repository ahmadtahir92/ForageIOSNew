//
//  HomeFarmsViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MediaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FBSDKLoginButtonDelegate {

    var endpoint: String = ""
    static var eventTracker = EventTracker()
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    var mediaPostsDictionary: [[String: Any]] = []
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2.0
    fileprivate let param_no_login = [
        "fields": "picture,posts.limit(5){message, full_picture, link, created_time, picture}",
        "access_token" : "1858566144400620|87fdfe5d523899c3d512fe6e87145bf1"
    ]
    fileprivate let query_param = ["fields": "picture,posts.limit(5){message, full_picture, link, created_time, picture}"]
    
    fileprivate let feed_name = "/MVFarmersMkt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]

        if ((FBSDKAccessToken.current()) != nil) {
            self.getFeed(feed_param: query_param)
        } else {
            self.getFeed(feed_param: param_no_login)
        }

        // Do any additional setup after loading the view.
        MediaViewController.eventTracker.trackScreenEvent(screenType: Constants.GA_MEDIA_SCREEN)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error != nil) {
            print(error)
            return
        }
        
        self.getFeed(feed_param: query_param)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaPostsDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! myFeedCell
        
        if self.mediaPostsDictionary.isEmpty {
            return cell
        }
        
        if self.mediaPostsDictionary[indexPath.row]["picture"] != nil {
            let urlString = self.mediaPostsDictionary[indexPath.row]["picture"] as! String?
            
            self.downloadImage(urlString!, feedImage: cell.feedImage)
            
            if let status = self.mediaPostsDictionary[indexPath.row]["message"] as! String? {
                cell.feedStatus.text = status
            }
            
            if let link = self.mediaPostsDictionary[indexPath.row]["link"] as! String? {
                cell.urlLink = link
            }
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 5
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: [],
            animations: { cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) },
                completion: { finished in
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: .curveEaseInOut,
                        animations: { cell.transform = CGAffineTransform(scaleX: 1, y: 1) },
                        completion: nil)
            })
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
     let feedHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "feedHeader", for: indexPath) as! feedHeader
     
     feedHeaderView.feedHeaderLabel.text = "Media Feed"
     
     return feedHeaderView
     }*/
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let link = self.mediaPostsDictionary[indexPath.row]["link"] as! String? {
            let url = URL(string: link)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    // UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func downloadImage(_ uri : String, feedImage: UIImageView){
        
        let url = URL(string: uri)
        
        let task = URLSession.shared.dataTask(with: url!) {responseData,response,error in
            if error == nil{
                if let data = responseData {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            feedImage.image = image
                            //imageButton.setBackgroundImage(UIImage(data: data), for: UIControlState.normal)
                        }
                    }
                    
                }else {
                    print("no data")
                }
            }else{
                print(error!)
            }
        }
        
        task.resume()
        
    }
    
    func getFeed(feed_param: [AnyHashable: Any]) {
        FBSDKGraphRequest(graphPath: feed_name, parameters: feed_param).start {
            (connection, result, err) in
            
            if (err != nil) {
                print("Graph request failed:",err!)
            }
            
            
            let mediaFeed:[String: Any] = result as! [String: Any]
            
            self.mediaPostsDictionary = ((mediaFeed as AnyObject).object(forKey: "posts") as AnyObject).object(forKey: "data")! as! [[String: Any]]
            self.feedCollectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Media", image: #imageLiteral(resourceName: "media_icon"), tag: 2)
    }
}
