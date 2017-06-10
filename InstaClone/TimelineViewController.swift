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
    var contentArray:[DataSnapshot] = []
    var snap:DataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "check") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }else {
            print("ログイン成功")
            self.read()
            timelineTableView.rowHeight = UITableViewAutomaticDimension
            
            let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
            timelineTableView.register(nib, forCellReuseIdentifier: "postCell")
            
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func read()  {
        let firebaseRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        firebaseRef.child((Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapshots) in
            if snapshots.children.allObjects is [DataSnapshot] {
                print("snapShots.children...\(snapshots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapshots)") //読み込んだデータをプリント
                
                self.snap = snapshots
                
            }
            self.reload(snap: self.snap)
        })
    }
    
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            let firebaseRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
            firebaseRef.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            timelineTableView.reloadData()
        }
    }
    
    
}


extension TimelineViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
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


