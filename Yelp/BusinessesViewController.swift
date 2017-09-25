//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Deepthy on 9/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import ACProgressHUD_Swift
import AFNetworking

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    fileprivate var loadMoreView: InfiniteScrollActivityView!
    fileprivate var isMoreDataLoading = false
    let progressView = ACProgressHUD.shared

    fileprivate func getInfiniteScrollFrame() -> CGRect {
        return CGRect(
            x: 0,
            y: tableView.contentSize.height,
            width: tableView.bounds.size.width,
            height: InfiniteScrollActivityView.defaultHeight
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        if(searchBar == nil) {
        
            searchBar = UISearchBar()
            searchBar.sizeToFit()
            searchBar.placeholder = Constants.restaurants
            searchBar.tintColor = ThemeManager.currentTheme().secondaryColor.withAlphaComponent(0.5)
            searchBar.searchBarStyle = .prominent
        }
        searchBar.isTranslucent=false

        searchBar.delegate = self

        navigationItem.titleView = searchBar
        navigationController!.navigationBar.barTintColor = ThemeManager.currentTheme().mainColor
        navigationController!.navigationBar.tintColor = ThemeManager.currentTheme().backgroundColor
        navigationController!.navigationBar.isTranslucent = false
        
        
        // Infinite scroll view setup
        loadMoreView = InfiniteScrollActivityView(frame: getInfiniteScrollFrame())
        tableView.contentInset.bottom += InfiniteScrollActivityView.defaultHeight
        
        progressView.progressText = Constants.progressText
        progressView.showHudAnimation = .growIn

        progressView.showHUD()

        guard let businessList = businesses, businessList.count != 0 else {

            performSearch("")
            
            return
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let  selection = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selection, animated: false)
        }

        progressView.hideHUD()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == Constants.segueFilterIdentifier {

            let navigationController = segue.destination as! UINavigationController
        
            let filterViewController = navigationController.topViewController as! FiltersViewController
            filterViewController.delegate = self
            
        }
        else if segue.identifier == Constants.segueMapSearchIdentifier {
            
            let mapViewController = (segue.destination as! UINavigationController).topViewController as! MapViewController
            mapViewController.businesses = businesses
            mapViewController.searchBar = searchBar

        }
        else {
            
            if let cell = sender as? BusinessCell {
                let  indexPath = tableView.indexPath(for: cell)
                
                let selectedBusiness = businesses[(indexPath?.row)!]

                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.business = selectedBusiness
                }
            }
        }
    }
    
    final func performSearch(_ term: String) {

        if term != nil, term != "" {

            Business.searchWithTerm(term: term, sort: nil, categories: [Constants.restaurants.lowercased()], deals: nil, distance: 0) { (businesses: [Business]?, errror: Error?) in
                if let businesses = businesses {
                    self.businesses = businesses
                    self.tableView.reloadData()
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
            }
        }
        else {

            Business.searchWithTerm(term: Constants.restaurants, completion: { (businesses: [Business]?, error: Error?) -> Void in
                
                self.businesses = businesses
                self.tableView.reloadData()
                
            })
        }
        
    }
}

// MARK: - TableView Datasource and Delegate methods

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.businessReuseIdentifier, for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    
}


// MARK: - SearchBar Delegate methods

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.performSearch(searchBar.text!)
    }
    
    final func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)

        self.performSearch(searchBar.text!)

    }

}


// MARK: - Scrollview Delegate methods

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                self.loadMoreView.frame = CGRect(
                    x: 0,
                    y: scrollOffsetThreshold,
                    width: scrollView.bounds.width,
                    height: InfiniteScrollActivityView.defaultHeight
                )
                self.loadMoreView.startAnimating()
            }
        }
    }
}


// MARK: - Filter Delegate methods

extension BusinessesViewController: FiltersViewControllerDelegate {

    func filterViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters[Constants.filterCategories] as? [String]
        
        let deals = filters[Constants.filterDeals] as? Bool
        
        let sort = filters[Constants.filterSort] as? Int
        
        let distance = filters[Constants.filterDistance] as? Int

        Business.searchWithTerm(term: Constants.restaurants, sort: YelpSortMode(rawValue: sort!)!, categories:  categories, deals: deals, distance: distance!) { (businesses: [Business]?, errror: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        

    }
}


