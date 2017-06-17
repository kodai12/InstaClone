//
//  FavoriteTableViewCell.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/11.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteIconImage: UIImageView!
    @IBOutlet weak var favoriteUserName: UILabel!
    @IBOutlet weak var favoritePostedImage: UIImageView!
    @IBOutlet weak var favoriteUnderUserName: UILabel!
    @IBOutlet weak var favoriteCommentText: UILabel!
    
    private func updateUI(){
        favoriteIconImage.layer.cornerRadius = favoriteIconImage.layer.bounds.width/2
        favoriteIconImage.clipsToBounds = true
        favoritePostedImage.layer.cornerRadius = 5.0
        favoritePostedImage.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
