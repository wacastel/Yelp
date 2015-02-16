//
//  Business.swift
//  Yelp
//
//  Created by William Castellano on 2/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    
    var imageUrl: NSString?
    var name: NSString?
    var ratingImageUrl: NSString?
    var numReviews: NSInteger?
    var address: NSString?
    var categories: NSString?
    var distance: Float?
    
    func initWithDictionary(dictionary: NSDictionary) {
        var categories: NSArray = dictionary["categories"] as NSArray
        var categoryNames: NSMutableArray = NSMutableArray()
        categories.enumerateObjectsUsingBlock { (obj: AnyObject!, idx: NSInteger, stop: UnsafeMutablePointer) -> Void in
            categoryNames.addObject(obj[0])
        }
        self.categories = categoryNames.componentsJoinedByString(", ")
        self.name = dictionary["name"] as String
        if (dictionary["image_url"] != nil) {
            self.imageUrl = dictionary["image_url"] as String
        }
        var location: NSDictionary = dictionary["location"] as NSDictionary
        var myAddressArray = location["address"] as NSArray
        var myStreet = ""
        if (myAddressArray.count > 0) {
            myStreet = myAddressArray[0] as NSString
        }
        var myNeighborhood = ""
        if location["neighborhoods"] != nil {
            var myNeighborhoodsArray = location["neighborhoods"] as NSArray
            myNeighborhood = myNeighborhoodsArray[0] as NSString
        }
        if (myStreet != "") {
            self.address = NSString(format: "%@, %@", myStreet, myNeighborhood)
        } else {
            self.address = NSString(format: "%@", myNeighborhood)
        }
        self.numReviews = dictionary["review_count"]?.integerValue
        self.ratingImageUrl = dictionary["rating_img_url"] as? NSString
        var milesPerMeter:Float = 0.000621371
        self.distance = dictionary["distance"] as Float * milesPerMeter
    }
    
    class func businessesWithDictionaries (dictionaries: NSArray) -> NSArray {
        
        var businesses = [Business]()
        for dictionary in dictionaries {
            var business = Business()
            business.initWithDictionary(dictionary as NSDictionary)
            businesses.append(business)
        }
        return businesses
    }
   
}
