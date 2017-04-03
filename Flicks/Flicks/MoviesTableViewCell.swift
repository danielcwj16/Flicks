//
//  MoviesTableViewCell.swift
//  Flicks
//
//  Created by Weijie Chen on 3/30/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_overview: UILabel!
    
    var posterPath : String?
    var movieId : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
