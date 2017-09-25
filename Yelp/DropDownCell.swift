//
//  DropDownCell.swift
//  Yelp
//
//  Created by Deepthy on 9/21/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    @IBOutlet weak var dropDownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
