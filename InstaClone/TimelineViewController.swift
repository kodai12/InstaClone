//
//  TimelineViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timelineTableView: UITableView!
    var posts:[Post] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        if UserDefaults.standard.object(forKey: "loginCheck") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }else {
            print("ログイン成功")
            posts = []
            loadData()
            timelineTableView.reloadData()
            timelineTableView.rowHeight = UITableViewAutomaticDimension
            let nib = UINib(nibName: "TableViewCell", bundle: nil)
            timelineTableView.register(nib, forCellReuseIdentifier: "postCell")
            
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
            // UIRefreshControlの設定
            refreshControl.attributedTitle = NSAttributedString(string: "refresh timeline")
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            timelineTableView.addSubview(refreshControl)
        }
    }
    
    func refresh(){
        posts = []
        loadData()
        timelineTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadData() {
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var postsMap = [Int:Post]()
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapshot) in
            for (postId,child) in snapshot.children.enumerated() {
                let key:String = (child as AnyObject).key
                userRef.child("Posts").child(key).observeSingleEvent(of: .value, with: {(snapshot) in
                    postsMap[postId] = self.extractPosts(snapshot)
                    var sortedPosts = [Post]()
                    for (postId,_) in snapshot.children.enumerated() {
                        if let unwrappedPostmap = postsMap[postId]{
                            sortedPosts.append(unwrappedPostmap)
                        }
                    }
                    self.posts = sortedPosts
                    self.posts = self.posts.reversed()
                    self.timelineTableView.reloadData()
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TimelineTableViewCell
        
        // 取得したデータをviewに表示
        let post = posts[indexPath.row]
        cell.userNameLabel.text = post.userName
        cell.underUserNameLabel.text = post.userName
        cell.commentLabel.text = post.comment
        let decodProfileData = NSData(base64Encoded: post.profileImageURL, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodeProfileImage = UIImage(data: decodProfileData! as Data)
        cell.iconImageView.image = decodeProfileImage!
        let decodPostedData = NSData(base64Encoded: post.postedImageURL, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodePostedImage = UIImage(data: decodPostedData! as Data)
        cell.postedImageView.image = decodePostedImage!
        
        cell.updateUI()
        cell.configureButtonUI()
        
        cell.getPosts = [post]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


