//
//  TimelineTableViewCell.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var snsButton: SpringButton!
    
    
    private func updateUI(){
        
        iconImageView.layer.cornerRadius = iconImageView.layer.bounds.width/2
        iconImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 5.0
        postImageView.clipsToBounds = true

    }
    
    private func configureButtonUI(){
        likeButton.layer.cornerRadius = 3.0
        likeButton.layer.borderWidth = 2.0
        likeButton.layer.borderColor = UIColor.lightGray.cgColor
        likeButton.tintColor = UIColor.lightGray
        
        commentButton.layer.cornerRadius = 3.0
        commentButton.layer.borderWidth = 2.0
        commentButton.layer.borderColor = UIColor.lightGray.cgColor
        commentButton.tintColor = UIColor.lightGray
        
        snsButton.layer.cornerRadius = 3.0
        snsButton.layer.borderWidth = 2.0
        snsButton.layer.borderColor = UIColor.lightGray.cgColor
        snsButton.tintColor = UIColor.lightGray
        
        configureButtonUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func clickLikeButton(_ sender: Any) {
        likeButton.animation = "pop"
        likeButton.curve = "spring"
        likeButton.duration = 15.0
        likeButton.damping = 1.0
        likeButton.velocity = 2.0
        likeButton.animate()
    }
    
    @IBAction func clickCommentButton(_ sender: Any) {
        commentButton.animation = "pop"
        commentButton.curve = "spring"
        commentButton.duration = 15.0
        commentButton.damping = 1.0
        commentButton.velocity = 2.0
        commentButton.animate()
    }
    
    @IBAction func clickSNSButton(_ sender: Any) {
        snsButton.animation = "pop"
        snsButton.curve = "spring"
        snsButton.duration = 15.0
        snsButton.damping = 1.0
        snsButton.velocity = 2.0
        snsButton.animate()
    }
    
    
}
