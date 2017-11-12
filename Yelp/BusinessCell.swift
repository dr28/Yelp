//
//  BusinessCell.swift
//  Yelp
//
//  Created by Deepthy on 9/19/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet private weak var thumbImgView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var ratingsImgView: UIImageView!
    @IBOutlet private weak var reviewsCountLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    
    var business: Business! {
        
        didSet {
            nameLabel.text = business.name
            if let imageURL = business.imageURL {
                thumbImgView.setImageWith(imageURL)
            }
            distanceLabel.text = business.distance
            ratingsImgView.setImageWith(business.ratingImageURL!)
            
            let reviewCount = business.reviewCount
            reviewsCountLabel.text = reviewCount == 1 ? "\(reviewCount!) \(Constants.reviewLabel)" : "\(reviewCount!) \(Constants.reviewsLabel)"
            
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
