//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Olya Sorokina on 10/14/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
