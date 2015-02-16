//
//  FiltersViewController.swift
//  Yelp
//
//  Created by William Castellano on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func didChangeFilters(filtersViewController: FiltersViewController, filters: NSDictionary)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FiltersViewControllerDelegate?
    var filters: NSDictionary = NSDictionary()
    var categories: NSArray?
    var sortingMethods: NSArray?
    var distances: NSArray?
    var deals: NSArray?
    var selectedCategories: NSMutableSet? = NSMutableSet()
    var selectedDistances: NSMutableSet? = NSMutableSet()
    var selectedSorts: NSMutableSet? = NSMutableSet()
    var selectedDeals: NSMutableSet? = NSMutableSet()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initCategories()
        self.initSortingMethods()
        self.initDistances()
        self.initDeals()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancelButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "onApplyButton")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didUpdateValue(cell: SwitchCell, value: Bool?) {
        var indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
        var section: Int = indexPath.section
        
        // For sections 1 and 2, deselect selected switch when a new switch is selected
        // reason for this is only 1 switch can be selected at a time for those sections
        
        switch (section) {
        case 0:
            // Section 0: deals
            if (value!) {
                self.selectedDeals?.addObject(self.deals![indexPath.row] as NSDictionary)
            } else {
                self.selectedDeals?.removeObject(self.deals![indexPath.row] as NSDictionary)
            }
        case 1:
            // Section 1: distance
            if (value!) {
                self.selectedDistances?.removeAllObjects()
                self.selectedDistances?.addObject(self.distances![indexPath.row] as NSDictionary)
                cellToggle(section, givenRow: indexPath.row)
                
            } else {
                self.selectedDistances?.removeObject(self.distances![indexPath.row] as NSDictionary)
            }
        case 2:
            // Section 2: sort
            if (value!) {
                self.selectedSorts?.removeAllObjects()
                self.selectedSorts?.addObject(self.sortingMethods![indexPath.row] as NSDictionary)
                cellToggle(section, givenRow: indexPath.row)
            } else {
                self.selectedSorts?.removeObject(self.sortingMethods![indexPath.row] as NSDictionary)
            }
        case 3:
            // Section 3: categories
            if (value!) {
                self.selectedCategories?.addObject(self.categories![indexPath.row] as NSDictionary)
            } else {
                self.selectedCategories?.removeObject(self.categories![indexPath.row] as NSDictionary)
            }
        default:
            println("error!")
        }
    }
    
    // Toggles off all cells in a given section except for the one at the given row
    func cellToggle(section: Int, givenRow: Int) {
        // loop through all cells except the cell at indexPath.row and switch them off
        for (var row = 0; row < tableView.numberOfRowsInSection(section); row++) {
            if (row != givenRow) {
                let cellPath = NSIndexPath(forRow: row, inSection: section)
                let cell = tableView.cellForRowAtIndexPath(cellPath) as SwitchCell
                cell.setOn(false)
            }
        }
    }
    
    func setFilters() -> NSDictionary {
        var myFilters: NSMutableDictionary = NSMutableDictionary()
        
        // set category filters
        if (self.selectedCategories?.count > 0) {
            var codesArray: NSMutableArray = NSMutableArray()
            for element in self.selectedCategories! {
                if let myElement: NSDictionary = element as? NSDictionary {
                    codesArray.addObject(myElement["code"] as NSString)
                }
            }
            let elementFilter: NSString = codesArray.componentsJoinedByString(",")
            myFilters.setObject(elementFilter, forKey: "category_filter")
        }
        
        // set deals filter
        if (self.selectedDeals?.count > 0) {
            var codesArray: NSMutableArray = NSMutableArray()
            for element in self.selectedDeals! {
                if let myElement: NSDictionary = element as? NSDictionary {
                    codesArray.addObject(myElement["code"] as NSString)
                }
            }
            // just get the first element in the array since only one cell at a time can be selected
            let elementFilter: NSString = codesArray[0] as NSString
            myFilters.setObject(elementFilter, forKey: "deals_filter")
            
            if (self.selectedDeals?.count > 1) {
                println("*** warning: more than one deal selected! ***")
            }
        }
        
        //set distance filter
        if (self.selectedDistances?.count > 0) {
            var codesArray: NSMutableArray = NSMutableArray()
            for element in self.selectedDistances! {
                if let myElement: NSDictionary = element as? NSDictionary {
                    codesArray.addObject(myElement["code"] as NSString)
                }
            }
            // just get the first element in the array since only one cell at a time can be selected
            let elementFilter: NSString = codesArray[0] as NSString
            myFilters.setObject(elementFilter, forKey: "radius_filter")
            
            if (self.selectedDistances?.count > 1) {
                println("*** warning: more than one distance selected! ***")
            }
        }
        
        //set sort filter
        if (self.selectedSorts?.count > 0) {
            var codesArray: NSMutableArray = NSMutableArray()
            for element in self.selectedSorts! {
                if let myElement: NSDictionary = element as? NSDictionary {
                    codesArray.addObject(myElement["code"] as NSString)
                }
            }
            // just get the first element in the array since only one cell at a time can be selected
            let elementFilter: NSString = codesArray[0] as NSString
            myFilters.setObject(elementFilter, forKey: "sort")
            
            if (self.selectedSorts?.count > 1) {
                println("*** warning: more than one sort selected! ***")
            }
        }
        
        return myFilters
    }
    
    func onCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onApplyButton() {
        self.filters = self.setFilters()
        self.delegate?.didChangeFilters(self, filters: self.filters)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            // Section 0: deals
            return "Most Popular"
        case 1:
            // Section 1: distance
            return "Distance"
        case 2:
            // Section 2: sort
            return "Sort by"
        case 3:
            // Section 3: categories
            return "Categeory"
        default:
            return "Default"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            // Section 0: deals
            return 1
        case 1:
            // Section 1: distance
            if let entries = self.distances {
                return entries.count
            }
            else {
                return 0
            }
        case 2:
            // Section 2: sort
            if let entries = self.sortingMethods {
                return entries.count
            }
            else {
                return 0
            }
        case 3:
            // Section 3: categories
            if let cat = self.categories {
                return cat.count
            }
            else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            // Section 0: deals
            let cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.titleLabel.text = self.deals![indexPath.row]["label"] as? NSString
            cell.setOn(self.selectedDeals!.containsObject(self.deals![indexPath.row]))
            cell.delegate = self
            return cell
        case 1:
            // Section 1: distance
            let cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.titleLabel.text = self.distances![indexPath.row]["label"] as? NSString
            cell.setOn(self.selectedDistances!.containsObject(self.distances![indexPath.row]))
            cell.delegate = self
            return cell
        case 2:
            // Section 2: sort
            let cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.titleLabel.text = self.sortingMethods![indexPath.row]["label"] as? NSString
            cell.setOn(self.selectedSorts!.containsObject(self.sortingMethods![indexPath.row]))
            cell.delegate = self
            return cell
        case 3:
            // Section 3: categories
            let cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.titleLabel.text = self.categories![indexPath.row]["name"] as? NSString
            cell.setOn(self.selectedCategories!.containsObject(self.categories![indexPath.row]))
            cell.delegate = self
            return cell
        default:
            let cell:SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as SwitchCell
            cell.titleLabel.text = "Error!"
            cell.setOn(false)
            cell.delegate = self
            return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initDeals() {
        self.deals = [
            ["label" : "Offering a Deal", "code": "true"]
        ]
    }
    
    func initDistances() {
        self.distances = [
            ["label" : "0.5 miles", "code": "800"],
            ["label" : "1 mile", "code": "1600"],
            ["label" : "5 miles", "code": "8000"],
            ["label" : "10 miles", "code": "16000"]
        ]
    }
    
    func initSortingMethods() {
        self.sortingMethods = [
            ["label" : "Best Match", "code": "0"],
            ["label" : "Distance", "code": "1"],
            ["label" : "Highest Rated", "code": "2"]
        ]
    }
    
    func initCategories() {
        self.categories = [
            ["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New]"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"]
        ]
    }

}
