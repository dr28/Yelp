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
    @IBOutlet weak var onSwitch: CustomSwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        onSwitch.addTarget(self, action: "switchValueChanged", for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        onSwitch.onTintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        onSwitch.offTintColor = .lightGray
        onSwitch.areLabelsShown = true
        onSwitch.labelOff.text = "OFF"
        onSwitch.labelOn.text = "ON"
        let thumbImage = UIImage(named: "yelpthumb")!
        let thumbImageView = UIImageView(image: thumbImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        onSwitch.thumbImage = thumbImageView.image
        onSwitch.tintColor = onSwitch.isOn ? UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1) : UIColor.lightGray
    }
    
    func switchValueChanged() {
        onSwitch.tintColor = onSwitch.isOn ? UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1) : UIColor.lightGray
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
}
