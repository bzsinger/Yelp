//
//  BusinessCell.swift
//  Yelp
//
//  Created by Benny Singer on 2/13/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var number = 0
    
    var business: Business! {
        didSet {
            nameLabel.text = "\(number). \(business.name!)"
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
    
    @IBOutlet weak var categoriesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() //always call parent function when overriding in views
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
