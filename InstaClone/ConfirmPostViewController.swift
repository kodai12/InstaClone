//
//  ConfirmPostViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/10.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class ConfirmPostViewController: UIViewController {

    @IBOutlet weak var getIconImageView: UIImageView!
    @IBOutlet weak var getUserNameLabel: UILabel!
    @IBOutlet weak var getPostImageView: UIImageView!
    @IBOutlet weak var getCommentTextLabel: UILabel!
    
    var editImage = UIImage()
    var editComment = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 遷移元から受け取ったデータを表示
        getPostImageView.image = editImage
        getCommentTextLabel.text = editComment
        
        // データベースからユーザー名とプロフィール画像を取り出し表示
        getIconImageView.layer.cornerRadius = 8.0
        getIconImageView.clipsToBounds = true
        
        if UserDefaults.standard.object(forKey: "profileImage") != nil{
            let decodeData = UserDefaults.standard.object(forKey: "profileImage")
            let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodeImage = UIImage(data: decodedData as! Data)
            getIconImageView.image = decodeImage
            
            getUserNameLabel.text = UserDefaults.standard.object(forKey: "userName") as? String
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
    }
    
    @IBAction func clickPost(_ sender: Any) {
        let databaseRef = Database.database().reference()
        
        /*
         渡しているデータに問題がありtimelineに表示されていない可能性が高いのでデータが正確に渡せているかを一度確認する
         userName,commentに関して：Optional型の取扱い考える
         各変数の中身、渡り方を確認
        */
        
        //ユーザー名
        let userName = getUserNameLabel.text!
        //コメント
        let comment = getCommentTextLabel.text!
        //投稿画像
        var postData:NSData = NSData()
        if let tempPostImage = getPostImageView.image{
            postData = UIImageJPEGRepresentation(tempPostImage, 0.1)! as NSData
        }
        let postImage = postData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        //プロフィール画像
        var iconData:NSData = NSData()
        if let tempIconImage = getPostImageView.image{
            iconData = UIImageJPEGRepresentation(tempIconImage, 0.1)! as NSData
        }
        let iconImage = iconData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        //dict型でまとめる
        let user:NSDictionary = ["userName":userName, "comment":comment,"profileImage":iconImage,"postedImage":postImage]
        databaseRef.child("Posts").childByAutoId().setValue(user)
        //投稿が完了したらタイムラインに戻る
        _ = self.navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



}
