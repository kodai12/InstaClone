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
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var underUserNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    @IBOutlet weak var snsButton: DesignableButton!
    
    var post: Post!{
        didSet{
            updateUI()
        }
    }
    
    private var currentUserDidLike: Bool = false
    
    func updateUI(){
        
        iconImageView.layer.cornerRadius = iconImageView.layer.bounds.width/2
        iconImageView.clipsToBounds = true
        postedImageView.layer.cornerRadius = 5.0
        postedImageView.clipsToBounds = true
        
        //ロード時のLike数を反映したLI¥ikeButtonを設定
        likeButton.setTitle("\(post.numberOfDidLikes)👍", for: .normal)
        
    }
    
    func configureButtonUI(){
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 1.0
        likeButton.borderColor = UIColor.lightGray
        likeButton.tintColor = UIColor.lightGray
        
        commentButton.cornerRadius = 3.0
        commentButton.borderWidth = 1.0
        commentButton.borderColor = UIColor.lightGray
        commentButton.tintColor = UIColor.lightGray
        
        snsButton.cornerRadius = 3.0
        snsButton.borderWidth = 1.0
        snsButton.borderColor = UIColor.lightGray
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
        likeButton.duration = 1.5
        likeButton.damping = 0.1
        likeButton.velocity = 0.2
        likeButton.animate()
        
        post.userDidLike = !post.userDidLike
        if post.userDidLike{
            post.numberOfDidLikes += 1
        } else{
            post.numberOfDidLikes -= 1
        }
        currentUserDidLike = post.userDidLike
        
        likeButton.setTitle("\(post.numberOfDidLikes)👍", for: .normal)
    }
    
    @IBAction func clickCommentButton(_ sender: Any) {
        commentButton.animation = "pop"
        commentButton.curve = "spring"
        commentButton.duration = 1.5
        commentButton.damping = 0.1
        commentButton.velocity = 0.2
        commentButton.animate()
    }
    
    @IBAction func clickSNSButton(_ sender: Any) {
        snsButton.animation = "pop"
        snsButton.curve = "spring"
        snsButton.duration = 1.5
        snsButton.damping = 0.1
        snsButton.velocity = 0.2
        snsButton.animate()
    }
    
    
}
