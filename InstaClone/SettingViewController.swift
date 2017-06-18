//
//  SettingViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingUserNameLabel: UILabel!
    @IBOutlet weak var settingCollectionView: UICollectionView!
    var currentMyPost:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingCollectionView.dataSource = self
        
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
        
        currentMyPost = []
        loadMyData()
        settingCollectionView.reloadData()
    }
    
    func loadMyData() {
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var postsMap = [Int:Post]()
        userRef.child("Posts").observe(.value, with: {(snapshot) in
            for (postId,child) in snapshot.children.enumerated() {
                let key:String = (child as AnyObject).key
                userRef.child("Posts").child(key).queryOrdered(byChild: (Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapshot) in
                    postsMap[postId] = self.extractPosts(snapshot)
                    var sortedPosts = [Post]()
                    for (postId,_) in snapshot.children.enumerated() {
                        if let unwrappedPostmap = postsMap[postId]{
                            sortedPosts.append(unwrappedPostmap)
                        }
                    }
                    self.currentMyPost = sortedPosts
                    self.currentMyPost = self.currentMyPost.reversed()
                    self.settingCollectionView.reloadData()
                })
            }
            
        })
    }
    
    func extractPosts(_ snapshot: DataSnapshot) -> Post{
        let data = snapshot.value as! Dictionary<String,Any>
        let userName = data["userName"] as! String
        let comment = data["comment"] as! String
        let profileImageURL = data["profileImage"] as! String
        let postedImageURL = data["postedImage"] as! String
        return Post(userName: userName, profileImageURL: profileImageURL, postedImageURL: postedImageURL, comment: comment)
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMyPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as! SettingCollectionViewCell
        
        // 取得したpostedImageをviewに表示
        let post = currentMyPost[indexPath.row]
        let decodPostedData = NSData(base64Encoded: post.postedImageURL, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodePostedImage = UIImage(data: decodPostedData! as Data)
        cell.postImage.image = decodePostedImage!
        
        cell.updateUI()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
