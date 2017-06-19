//
//  FavoriteViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoritePosts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        favoritePosts = []
        loadData()
        favoriteTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var postsMap = [Int:Post]()
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapShot) in
            for (postId,child) in snapShot.children.enumerated() {
                let key:String = (child as AnyObject).key
                userRef.child("Posts").child(key).observeSingleEvent(of: .value, with: {(snapshot) in
                    postsMap[postId] = self.extractPosts(snapshot)
                    var sortedPosts = [Post]()
                    for (postId,_) in snapShot.children.enumerated() {
                        if let unwrappedPostmap = postsMap[postId]{
                            // お気に入りしたPost(userDidLike = trueとなっているPost)で条件分岐
                            if unwrappedPostmap.userDidLike{
                                sortedPosts.append(unwrappedPostmap)
                            }
                        }
                    }
                    self.favoritePosts = sortedPosts
                    self.favoritePosts = self.favoritePosts.reversed()
                    self.favoriteTableView.reloadData()
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
        let userDidLike = data["userDidLike"] as! Bool
        let numberOfDidLikes = data["numberOfDidLikes"] as! Int
        return Post(userName: userName, profileImageURL: profileImageURL, postedImageURL: postedImageURL, comment: comment, userDidLike:userDidLike, numberOfDidLikes:numberOfDidLikes)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        // 取得したデータをviewに表示
        let post = favoritePosts[indexPath.row]
        if post.userDidLike == true {
            cell.favoriteUserName.text = post.userName
            cell.favoriteUnderUserName.text = post.userName
            cell.favoriteCommentText.text = post.comment
            let decodProfileData = NSData(base64Encoded: post.profileImageURL, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodeProfileImage = UIImage(data: decodProfileData! as Data)
            cell.favoriteIconImage.image = decodeProfileImage!
            let decodPostedData = NSData(base64Encoded: post.postedImageURL, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodePostedImage = UIImage(data: decodPostedData! as Data)
            cell.favoritePostedImage.image = decodePostedImage!
        } else {
            return cell
        }
        
        return cell
    }

    
}
