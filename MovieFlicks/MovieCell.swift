//
//  MovieCell.swift
//  MovieFlicks
//
//  Created by Anisha Jain on 4/1/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//


import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var movieThumbnailView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

