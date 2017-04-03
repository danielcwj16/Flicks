//
//  TopRatedMovieTableViewCell.swift
//  Flicks
//
//  Created by Weijie Chen on 4/2/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class TopRatedMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var movie_title: UILabel!
    
    @IBOutlet weak var movie_overview: UILabel!
    
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
