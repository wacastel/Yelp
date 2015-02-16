//
//  SwitchCell.swift
//  Yelp
//
//  Created by William Castellano on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func didUpdateValue(cell: SwitchCell, value: Bool?)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: SwitchCellDelegate?
    var on: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        self.delegate?.didUpdateValue(self, value: self.toggleSwitch.on)
    }
    
    func setOn(onVal: Bool) {
        self.setOn(onVal, animated: false)
    }
    
    func setOn(onVal: Bool, animated: Bool) {
        on = onVal
        self.toggleSwitch.setOn(onVal, animated: animated)
    }
}
