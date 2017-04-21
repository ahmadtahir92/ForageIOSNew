//
//  SearchViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 3/4/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:SearchViewControllerDelegate?
    
    var fullFarmArr: [Farm]
    var farmArr: [Farm]
   
    var searchText = ""
    
    func cancelSearch() {
        delegate?.dismissSearch()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapFarmCard(_ sender: UIButton) {
        guard let cell = ControllerUtils.findCollectionCellFromField(sender: sender) else {
            // Err... not in collectionView???
            return
        }
        
        let indexPath = collectionView.indexPath(for: cell)
        let farm = farmArr[indexPath!.row]
        
        delegate?.dismissSearchWithDetailRequest(sender: self, requestId: farm.getFarmId())
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * Use two columns per row! - some sizing math here. :(
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        return CGSize(width: dimensions, height: dimensions)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.farmArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.foragelocal.searchFarmCell", for: indexPath) as! SearchFarmViewCell
        let farm = farmArr[indexPath.row]
        cell.setup(farm: farm, tapFunc: self.tapFarmCard)
        return cell
    }
    
    func getFarms() {
        // Show progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ParseHomeOwner.findAllFarms(completionHandler: { (farmList : [Farm]) -> Void in
            
            self.farmArr = [Farm]()
            self.fullFarmArr = farmList
            
            for farm in self.fullFarmArr {
                let farmName = farm.farmName
                if (farmName.contains(find: self.searchText)) {
                    self.farmArr.append(farm)
                }
            }
            
            self.collectionView.reloadData()
            
            // Hide progress bar
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Market Search Results"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelSearch))
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getFarms()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prep before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        // Init the vars
        self.farmArr = [Farm]()
        self.fullFarmArr = [Farm]()
        
        super.init(coder: aDecoder)
    }
}
