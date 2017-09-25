//
//  SwitchCell.swift
//  Yelp
//
//  Created by Deepthy on 9/20/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value:  Bool)
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var switchLabel: UILabel!

    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        onSwitch.addTarget(self, action: "switchValueChanged", for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {

        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
        
    }

}
