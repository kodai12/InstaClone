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
    
        // 現在のプロフィール画像とユーザー名を取得
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            let currentUserName = user?.displayName
            settingUserNameLabel.text = currentUserName
            let currentIconURL = user?.photoURL
            let URLreq = URLRequest(url: currentIconURL!)
            let conf = URLSessionConfiguration.default
            let session = URLSession(configuration: conf)
            session.dataTask(with: URLreq, completionHandler: {(data,resp,error) in
                if(error == nil){
                    let image = UIImage(data: data!)
                    self.settingIconImageView.image = image
                }else{
                    print("Error:\(error?.localizedDescription)")
                }
            }).resume()
            
            /*
             ログイン中のユーザーの投稿した画像を取得する
             ifでcurrentUserのuidとPostsの中のuserIdが一致した場合という条件文で場合分け
            */
        }else{
            print("Error!!")
        }
        
        
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        performSegue(withIdentifier: "toSetting", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
}
