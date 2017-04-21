//
//  ForageSearchContainer.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 3/8/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func dismissSearchWithDetailRequest(sender: SearchViewController, requestId: String)
    func dismissSearch()
}

// Helper parent class for handling the dictionary and search view delegates
class ForageSearchContainer: UIViewController, UISearchBarDelegate, SearchViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var dictionary: [String]
    
    var searchController: UISearchController!
    var searchText: String?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictEntry = self.dictionary[indexPath.row]
        
        let searchBar = searchController.searchBar
        self.searchText = dictEntry
        searchBar.text = dictEntry
        searchBarSearchButtonClicked(searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // do nothing - child must override!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictEntry = self.dictionary[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.foragelocal.dictionaryCell", for: indexPath) as! DictionaryCell
        
        cell.setup(dEntry: dictEntry)
        
        return cell
    }
    
    func dismissSearch() {
        DispatchQueue.main.async {
            self.searchController.isActive = false
        }
    }
    
    func dismissSearchWithDetailRequest(sender: SearchViewController, requestId: String) {
        dismissSearch()
        // A farm got clicked - jump to detail view
        performSegue(withIdentifier: "FarmDetailSegue", sender: requestId)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Save the search keywords
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let stoyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let searchViewController = stoyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            fatalError("Unable to instatiate a SearchResultsViewController from the storyboard.")
        }
        
        // As we are instantiating programatically - setup a navController as well!
        let navController = UINavigationController.init(rootViewController: searchViewController)
        
        searchViewController.delegate = self
        searchViewController.searchText = self.searchText!
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        
        // Don't dim the background
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        // Navigation bar hides when presenting the search interface.
        // Our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        // Set this view controller as the presenting view controller for the search interface!
        definesPresentationContext = false
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Init the vars
        self.dictionary = [String]()
        super.init(coder: aDecoder)
    }
}
