//
//  SettingViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingUserNameLabel: UILabel!
    @IBOutlet weak var settingCollectionView: UICollectionView!
    var currentMyPost = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データベースからユーザー名とプロフィール画像を取り出し表示
        settingIconImageView.layer.cornerRadius = settingIconImageView.frame.size.width/2
        settingIconImageView.clipsToBounds = true
        
        let userRef = Database.database().reference()
        userRef.child("Users").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                userRef.child("Users").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.settingUserNameLabel.text = snap["userName"] as? String
                        let iconData = snap["profileImage"] as! String
                        let decodeData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeImage = UIImage(data: decodeData as! Data)
                        self.settingIconImageView.image = decodeImage
                    }
                })
            }
        })
        
        /*
         ログイン中のユーザーの投稿した画像を取得する
         ifでcurrentUserのuidとPostsの中のuserIdが一致した場合という条件文で場合分け
         */
        
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
