//
//  NewsTableViewCell.swift
//  News
//
//  Created by Joaquin Jacinto on 8/13/19.
//  Copyright © 2019 Joaquin Jacinto. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
