//
//  SettingDetailViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/18.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase
import Social

class SettingDetailViewController: UIViewController {

    @IBOutlet weak var settingIconImage: UIImageView!
    @IBOutlet weak var settingUserName: UILabel!
    @IBOutlet weak var settingPostedImage: UIImageView!
    @IBOutlet weak var settingUnderUserName: UILabel!
    @IBOutlet weak var settingComment: UILabel!
    
    @IBOutlet weak var settingLikeButton: DesignableButton!
    @IBOutlet weak var settingCommentButton: DesignableButton!
    @IBOutlet weak var settingSNSButton: DesignableButton!
    
    var tempPostedImageURL:String?
    var tempComment:String?
    
    var myComposeView:SLComposeViewController?
    // セルを特定するための空の変数を用意
    var index:Int?
    
    var post: Post!
    var currentUserDidLike: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        configureButtonUI()
        
        let userRef = Database.database().reference()
        userRef.child("Users").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                userRef.child("Users").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.settingUserName.text = snap["userName"] as? String
                        self.settingUnderUserName.text = snap["userName"] as? String
                        let iconData = snap["profileImage"] as! String
                        let decodeData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeImage = UIImage(data: decodeData as! Data)
                        self.settingIconImage.image = decodeImage
                    }
                })
            }
        })
        
        
    }
    
    func updateUI(){
        if tempComment != nil, tempPostedImageURL != nil{
            settingComment.text = tempComment
            let decodePostedData = NSData(base64Encoded: tempPostedImageURL!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodePostedImage = UIImage(data: decodePostedData as! Data)
            settingPostedImage.image = decodePostedImage
        } else {
            print("tempComment or tempPostedImageURL are nil!")
        }
        
        settingIconImage.layer.cornerRadius = settingIconImage.layer.bounds.width/2
        settingIconImage.clipsToBounds = true
        settingPostedImage.layer.cornerRadius = 5.0
        settingPostedImage.clipsToBounds = true
        
        settingLikeButton.setTitle("\(post.numberOfDidLikes) 👍", for: .normal)
    }
    
    func configureButtonUI(){
        settingLikeButton.cornerRadius = 3.0
        settingLikeButton.borderWidth = 1.0
        settingLikeButton.borderColor = UIColor.lightGray
        settingLikeButton.tintColor = UIColor.lightGray
        
        settingCommentButton.cornerRadius = 3.0
        settingCommentButton.borderWidth = 1.0
        settingCommentButton.borderColor = UIColor.lightGray
        settingCommentButton.tintColor = UIColor.lightGray
        
        settingSNSButton.cornerRadius = 3.0
        settingSNSButton.borderWidth = 1.0
        settingSNSButton.borderColor = UIColor.lightGray
        settingSNSButton.tintColor = UIColor.lightGray
    }
    
    @IBAction func clickSettingLikeButton(_ sender: Any) {
        
        settingLikeButton.animation = "pop"
        settingLikeButton.curve = "spring"
        settingLikeButton.duration = 1.5
        settingLikeButton.damping = 0.1
        settingLikeButton.velocity = 0.2
        settingLikeButton.animate()
        
        post.userDidLike = !post.userDidLike
        if post.userDidLike{
            post.numberOfDidLikes += 1
        } else{
            post.numberOfDidLikes -= 1
        }
        currentUserDidLike = post.userDidLike
        settingLikeButton.setTitle("\(post.numberOfDidLikes) 👍", for: .normal)
        
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

    @IBAction func clickSettingCommentButton(_ sender: Any) {

        settingCommentButton.animation = "pop"
        settingCommentButton.curve = "spring"
        settingCommentButton.duration = 1.5
        settingCommentButton.damping = 0.1
        settingCommentButton.velocity = 0.2
        settingCommentButton.animate()
    
    }
    
    @IBAction func clickSettingSNSButton(_ sender: Any) {

        settingSNSButton.animation = "pop"
        settingSNSButton.curve = "spring"
        settingSNSButton.duration = 1.5
        settingSNSButton.damping = 0.1
        settingSNSButton.velocity = 0.2
        settingSNSButton.animate()
    
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
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func shareTwitter(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        //投稿するテキスト
        let string = "Photo by " + settingUserName.text!
        myComposeView?.setInitialText(string)
        myComposeView?.add(settingPostedImage?.image)
        //表示する
        self.present(myComposeView!, animated: true, completion: nil)
    }
    
    func shareFB(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        //投稿するテキスト
        let string = "Photo by " + settingUserName.text!
        myComposeView?.setInitialText(string)
        myComposeView?.add(settingPostedImage?.image)
        //表示する
        self.present(myComposeView!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickBackToSetting(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
}
