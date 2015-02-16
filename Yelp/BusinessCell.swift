//
//  BusinessCell.swift
//  Yelp
//
//  Created by William Castellano on 2/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBusiness(inputBusiness: Business) {
        self.business = inputBusiness
        if (self.business.imageUrl != nil) {
            self.thumbImageView.setImageWithURL(NSURL(string: self.business.imageUrl!))
        } else {
            self.thumbImageView.image = UIImage()
        }
        self.nameLabel.text = self.business.name
        self.ratingImageView.setImageWithURL(NSURL(string: self.business.ratingImageUrl!))
        self.ratingLabel.text = NSString(format: "%ld Reviews", self.business.numReviews!)
        self.addressLabel.text = self.business.address
        self.distanceLabel.text = NSString(format: "%.2f mi", self.business.distance!)
        self.categoryLabel.text = self.business.categories
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
    
}
