//
//  Login2ViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/11.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class Login2ViewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var firstSettingIconImage: UIImageView!
    @IBOutlet weak var firstSettingUserName: UITextField!
    
    var getUserName = String()
    var getIconImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstSettingIconImage.layer.cornerRadius = 8.0
        firstSettingIconImage.clipsToBounds = true
        
        firstSettingUserName.delegate = self
    }
    
    @IBAction func clickFirstIconSetting(_ sender: Any) {
        let alertViewController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "アルバム", style: .default, handler:{ (action:UIAlertAction) -> Void in
                self.openAlbum()
            })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertViewController.addAction(photoAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func openAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            firstSettingIconImage.contentMode = .scaleToFill
            firstSettingIconImage.image = pickedImage
            getIconImage = pickedImage
        }else{
            print("Something went wrong!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickFirstUserNameSetting(_ sender: Any) {
        getUserName = firstSettingUserName.text!
        firstSettingUserName.resignFirstResponder()
    }
    
    
    @IBAction func confirmFisrtSetting(_ sender: Any) {
        let databaseRef = Database.database().reference()
        
        //ユーザーID
        let userID = Auth.auth().currentUser?.uid
        //ユーザー名
        let userName = getUserName
        //プロフィール画像
        var iconData:NSData = NSData()
        if let tempIconImage = getIconImage{
            iconData = UIImageJPEGRepresentation(tempIconImage, 0.1)! as NSData
        }
        let iconImage = iconData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        //dict型でまとめる
        let user:NSDictionary = ["userID":userID!, "userName":userName,"profileImage":iconImage]
        databaseRef.child("Users").childByAutoId().setValue(user)
        //投稿が完了したらタイムラインに戻る
        _ = self.navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
    }

    @IBAction func firstSettingCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    
}
