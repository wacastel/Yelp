//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var client: YelpClient!
    var businesses: NSArray!
    var searchBar: UISearchBar!
    var filteredBusinesses: NSArray!
    var isSearching: Bool!
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        isSearching = false
        
        self.tableView.registerNib(UINib(nibName: "BusinessCell", bundle: nil), forCellReuseIdentifier: "BusinessCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 85
        
        self.title = "Yelp"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "onFilterButton")
        
        self.searchBar = UISearchBar(frame: CGRectZero)
        self.searchBar.delegate = self
        
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.titleView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        var myParams: NSDictionary = NSDictionary()
        self.fetchBusinessesWithQuery("Restaurants", params: myParams)
    }
    
    func fetchBusinessesWithQuery(query: NSString, params: NSDictionary) {
        
        println("query: \(query)")
        println("params: \(params)")
        
        client.searchWithTerm(query, params: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var businessDictionaries: NSArray = response["businesses"] as NSArray
            
            self.businesses = Business.businessesWithDictionaries(businessDictionaries)
            
            self.tableView.reloadData()
            
            //println(response)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isSearching == true {
            return self.filteredBusinesses.count
         } else {
            if let array = self.businesses {
                return self.businesses.count
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:BusinessCell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as BusinessCell
        
        // replace with filtered businesses when searching
        if isSearching == true {
            cell.setBusiness(self.filteredBusinesses[indexPath.row] as Business)
        } else {
            cell.setBusiness(self.businesses[indexPath.row] as Business)
        }
        return cell
    }
    
    func onFilterButton() {
        let vc = FiltersViewController(nibName: "FiltersViewController", bundle: nil)
        vc.delegate = self
        
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func didChangeFilters(filtersViewController: FiltersViewController, filters: NSDictionary) {
        // fire a new network event
        self.fetchBusinessesWithQuery("Restaurants", params: filters)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredBusinesses = (self.businesses as Array).filter({( business: Business) -> Bool in
            let lowerString = business.name?.lowercaseString
            let stringMatch = lowerString!.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text.isEmpty {
            isSearching = false
            tableView.reloadData()
        } else {
            //println("search text: %@", searchBar.text as NSString)
            isSearching = true
            self.filterContentForSearchText(searchBar.text)
            tableView.reloadData()
        }
    }
}

