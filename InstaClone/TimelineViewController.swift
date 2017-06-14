//
//  TimelineViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class TimelineViewController: UIViewController {

    @IBOutlet weak var timelineTableView: UITableView!
    var Posts: [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "loginCheck") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }else {
            print("ログイン成功")
            Posts = [:]
            loadData()
            timelineTableView.reloadData()
            timelineTableView.rowHeight = UITableViewAutomaticDimension
            
            let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
            timelineTableView.register(nib, forCellReuseIdentifier: "postCell")
            
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadData() {
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var tempItems:[String:Any] = [:]
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                userRef.child("Posts").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        // 各変数にDatabaseから取得した値を入れる
                        let userName = snap["userName"] as! String
                        let comment = snap["comment"] as! String
                        let iconData = (base64Encoded:snap["profileImage"] as! String)
                        let decodeIconData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeIconImage = UIImage(data: decodeIconData as! Data)
                        let iconImage: UIImage = decodeIconImage!
                        let postData = (base64Encoded:snap["postedImage"] as! String)
                        let decodePostData = NSData(base64Encoded: postData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodePostImage = UIImage(data: decodePostData as! Data)
                        let postedImage: UIImage = decodePostImage!

                        tempItems["userName"] = userName
                        tempItems["comment"] = comment
                        tempItems["iconImage"] = iconImage
                        tempItems["postedImage"] = postedImage
                        self.Posts = tempItems
                        self.timelineTableView.reloadData()
                    }
                })
            }
        })
    }
    
}


extension TimelineViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TimelineTableViewCell
        
        cell.getPosts = Posts
        return cell
    }
    
}


