//
//  SettingDetailViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/18.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class SettingDetailViewController: UIViewController {

    var selectedPost:[Post] = []

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
    
    override func viewDidLoad() {
        
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
        settingIconImage.layer.cornerRadius = settingIconImage.layer.bounds.width/2
        settingIconImage.clipsToBounds = true
        settingPostedImage.layer.cornerRadius = 5.0
        settingPostedImage.clipsToBounds = true
        
        if tempComment != nil, tempPostedImageURL != nil{
            settingComment.text = tempComment
            let decodePostedData = NSData(base64Encoded: tempPostedImageURL!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodePostedImage = UIImage(data: decodePostedData as! Data)
            settingPostedImage.image = decodePostedImage
        } else {
            print("tempComment or tempPostedImageURL are nil!")
        }
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
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickBackToSetting(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
}
