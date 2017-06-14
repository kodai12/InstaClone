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
    var userName = String()
    var iconImage = UIImage()
    var postImage = UIImage()
    var comment = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "loginCheck") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }else {
            print("ログイン成功")
            self.loadData()
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
        let userRef = Database.database().reference()
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                userRef.child("Posts").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.userName = snap["userName"] as! String
                        self.comment = snap["comment"] as! String
                        let iconData = snap["profileImage"] as! String
                        let decodeIconData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeIconImage = UIImage(data: decodeIconData as! Data)
                        self.iconImage = decodeIconImage!
                        let postData = snap["postImage"] as! String
                        let decodePostData = NSData(base64Encoded: postData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodePostImage = UIImage(data: decodePostData as! Data)
                        self.postImage = decodePostImage!
                    }
                })
            }
        })
            //テーブルビューをリロード
            timelineTableView.reloadData()
    }
    
}


extension TimelineViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TimelineTableViewCell
        
        
        let item = contentArray[indexPath.row]
        // itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String,Any>
        //
        cell.userNameLabel.text = content["userName"] as? String
        cell.iconImageView.image = content["progileImage"] as! UIImage?
        cell.postImageView.image = content["postedImage"] as! UIImage?
        cell.commentLabel.text = content["comment"] as? String
        
        return cell
    }
    
}


