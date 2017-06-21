//
//  TimelineTableViewCell.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase
import Social


class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var underUserNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    @IBOutlet weak var snsButton: DesignableButton!
    // セルを特定するための空の変数を用意
    var index: Int?
    
    var myComposeView:SLComposeViewController?
    
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
        likeButton.setTitle("\(post.numberOfDidLikes) 👍", for: .normal)
        
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
        likeButton.setTitle("\(post.numberOfDidLikes) 👍", for: .normal)
        
        // ボタンが押された時にDatabaseの値を更新
        let updateValues = ["userDidLike":currentUserDidLike, "numberOfDidLikes":post.numberOfDidLikes] as [String : Any]
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var keys = [String]()
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapShot) in
            for (_, child) in snapShot.children.enumerated() {
                let key:String = (child as AnyObject).key
                keys.append(key)
            }
            userRef.child("Posts").child(keys[self.index!]).updateChildValues(updateValues)
        })
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
        
        let alertViewController = UIAlertController(title: "Share?", message: "", preferredStyle: .actionSheet)
        let twitterShareAction = UIAlertAction(title: "Twitter", style: .default, handler:{ (action:UIAlertAction) -> Void in
            self.shareTwitter()
        })
        let FBShareAction = UIAlertAction(title: "Facebook", style: .default, handler:{ (action:UIAlertAction) -> Void in
            self.shareFB()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertViewController.addAction(twitterShareAction)
        alertViewController.addAction(FBShareAction)
        alertViewController.addAction(cancelAction)
        self.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)

    }
    
    func shareTwitter(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        //投稿するテキスト
        let string = "Photo by " + userNameLabel.text!
        myComposeView?.setInitialText(string)
        myComposeView?.add(postedImageView?.image)
        //表示する
        self.window?.rootViewController?.present(myComposeView!, animated: true, completion: nil)
    }
    
    func shareFB(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        //投稿するテキスト
        let string = "Photo by " + userNameLabel.text!
        myComposeView?.setInitialText(string)
        myComposeView?.add(postedImageView?.image)
        //表示する
        self.window?.rootViewController?.present(myComposeView!, animated: true, completion: nil)
    }
    
    
}
