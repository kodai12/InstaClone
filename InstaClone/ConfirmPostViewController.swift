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
    
    var items = [NSDictionary]()
    var editImage = UIImage()
    var editComment = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 遷移元から受け取ったデータを表示
        let postImageSize = CGRect(x: 16, y: 130, width: 340, height: 340)
        getPostImageView.frame = postImageSize
        getPostImageView.image = editImage
        getCommentTextLabel.text = editComment
        
        // データベースからユーザー名とプロフィール画像を取り出し表示
        getIconImageView.layer.cornerRadius = getIconImageView.frame.size.width/2
        getIconImageView.clipsToBounds = true
        
        let userRef = Database.database().reference()
        userRef.child("Users").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                userRef.child("Users").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.getUserNameLabel.text = snap["userName"] as? String
                        let iconData = snap["profileImage"] as! String
                        let decodeData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeImage = UIImage(data: decodeData as! Data)
                        self.getIconImageView.image = decodeImage
                    }
                })
            }
        })
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
    }
    
    @IBAction func clickPost(_ sender: Any) {
        let databaseRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        
        //ユーザーID
        let userID = Auth.auth().currentUser?.uid
        //ユーザー名
        let userName = getUserNameLabel.text!
        //コメント
        let comment = getCommentTextLabel.text!
        //投稿画像
        let postRatio = (getPostImageView.image?.size.width)! / (getPostImageView.image?.size.height)!
        let reSizedPostImage = resizedImage(originalImage: getPostImageView.image!, toWidth: imageSize.height * postRatio, andHeight: imageSize.height)
        let postData = UIImageJPEGRepresentation(reSizedPostImage, 0.1)! as NSData
        let postImage = postData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        //プロフィール画像
        var iconData:NSData = NSData()
        if let tempIconImage = getIconImageView.image{
            iconData = UIImageJPEGRepresentation(tempIconImage, 0.1)! as NSData
        }
        let iconImage = iconData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        //dict型でまとめる
        let user:NSDictionary = ["userID":userID!, "userName":userName, "comment":comment,"profileImage":iconImage,"postedImage":postImage]
        databaseRef.child("Posts").childByAutoId().setValue(user)
        //投稿が完了したらタイムラインに戻る
        let firstTVC: firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "firstTBC") as! firstViewController
        self.present(firstTVC, animated: true, completion: nil)
    }
    
    struct imageSize{
        static let height: CGFloat = 480
    }
    
    func resizedImage(originalImage: UIImage, toWidth width:CGFloat, andHeight height: CGFloat) -> UIImage{
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(newSize)
        originalImage.draw(in: newRectangle)
        
        let resizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    @IBAction func postCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
