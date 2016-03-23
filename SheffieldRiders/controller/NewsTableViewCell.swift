//
//  NewsTableViewCell.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 23/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsBody: UILabel!

    @IBOutlet weak var newsTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
