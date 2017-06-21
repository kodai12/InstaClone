//
//  SettingViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingUserNameLabel: UILabel!
    @IBOutlet weak var settingCollectionView: UICollectionView!
    var currentMyPost:[Post] = []
    
    var selectedPostedImageURL: String?
    var selectedComment: String?
    let refreshControl = UIRefreshControl()
    // セルを特定するための空の変数を用意
    var index:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingCollectionView.dataSource = self
        settingCollectionView.delegate = self
        
        // データベースからvarーザー名とプロフィール画像を取り出し表示
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
        // UIRefreshControlの設定
        refreshControl.attributedTitle = NSAttributedString(string: "refresh list")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        settingCollectionView.addSubview(refreshControl)
    
    }
    

    func refresh(){
        currentMyPost = []
        loadMyData()
        settingCollectionView.reloadData()
        refreshControl.endRefreshing()
    }

    func loadMyData() {
        let userRef = Database.database().reference(fromURL: "https://instaclone-653d2.firebaseio.com/")
        var postsMap = [Int:Post]()
        userRef.child("Posts").observeSingleEvent(of: .value, with: {(snapShot) in
            for (postId,child) in snapShot.children.enumerated() {
                let key:String = (child as AnyObject).key
                userRef.child("Posts").child(key).queryOrdered(byChild: (Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
                    postsMap[postId] = self.extractPosts(snapshot)
                    var sortedPosts = [Post]()
                    for (postId,_) in snapShot.children.enumerated() {
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
        let userDidLike = data["userDidLike"] as! Bool
        let numberOfDidLikes = data["numberOfDidLikes"] as! Int
        return Post(userName: userName, profileImageURL: profileImageURL, postedImageURL: postedImageURL, comment: comment, userDidLike:userDidLike, numberOfDidLikes:numberOfDidLikes)
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    @IBAction func clickSignOut(_ sender: Any) {
        let alertViewController = UIAlertController(title: "サインアウトしますか？", message: "", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "OK", style: .default, handler:{ (action:UIAlertAction) -> Void in
            self.signOutAction()})
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertViewController.addAction(signOutAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func signOutAction(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "loginCheck")
            //ログイン画面に遷移
            let loginVC: LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.present(loginVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedComment = currentMyPost[indexPath.row].comment
        selectedPostedImageURL = currentMyPost[indexPath.row].postedImageURL
        // Likeボタンが押された時に押されたPostのUserDidLikeとNumberOfDidLikesを更新
        // 押されたセルを特定するIndexPathの値を取得し、PostのID順に並べ直し、セルに値を渡す
        let reversedIndex = indexPath.row
        var array = [Int]()
        for i in (0...currentMyPost.count - 1).reversed(){
            array.append(i)
        }
        index = array[reversedIndex]
        if selectedComment != nil{
            performSegue(withIdentifier: "toDetail", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            
            if let detailVC: SettingDetailViewController = segue.destination as? SettingDetailViewController {
                if let unwrappedComment = selectedComment, let unwrappedPostedImageURL = selectedPostedImageURL{
                    detailVC.tempComment = unwrappedComment
                    detailVC.tempPostedImageURL = unwrappedPostedImageURL
                    detailVC.index = index
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
