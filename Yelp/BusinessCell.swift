//
//  BusinessCell.swift
//  Yelp
//
//  Created by Deepthy on 9/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImgView: UIImageView!
 
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImgView: UIImageView!
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        
        didSet {
            
            nameLabel.text = business.name
            if let imageURL = business.imageURL {
                thumbImgView.setImageWith(imageURL)
            }
            distanceLabel.text = business.distance
            ratingsImgView.setImageWith(business.ratingImageURL!)
            
            let reviewCount = business.reviewCount
            
            if (reviewCount == 1) {
                reviewsCountLabel.text = "\(reviewCount!) \(Constants.reviewLabel)"
            } else {
                reviewsCountLabel.text = "\(reviewCount!) \(Constants.reviewsLabel)"
            }

            addressLabel.text = business.address
            categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImgView.layer.cornerRadius = 3
        thumbImgView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        distanceLabel.tintColor = ThemeManager.currentTheme().secondaryColor
        reviewsCountLabel.tintColor = ThemeManager.currentTheme().secondaryColor
        categoriesLabel.tintColor = ThemeManager.currentTheme().secondaryColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
