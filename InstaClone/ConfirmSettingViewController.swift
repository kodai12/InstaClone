//
//  ConfirmSettingViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/11.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class ConfirmSettingViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var settingIconImage: UIImageView!
    @IBOutlet weak var settingUserNameText: UITextField!
    
    let reference = Database.database().reference()
    var newUserName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // データベースからユーザー名とプロフィール画像を取り出し設定前の画像・名前として表示
        settingIconImage.layer.cornerRadius = settingIconImage.frame.size.width/2
        settingIconImage.clipsToBounds = true
        
        reference.child("Users").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                self.reference.child("Users").child(key).observe(.value, with: {(snapshot) in
                    if let snap = snapshot.value as? [String:AnyObject]{
                        self.settingUserNameText.text = snap["userName"] as? String
                        let iconData = snap["profileImage"] as! String
                        let decodeData = NSData(base64Encoded: iconData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                        let decodeImage = UIImage(data: decodeData as! Data)
                        self.settingIconImage.image = decodeImage
                    }
                })
            }
        })
        
        settingUserNameText.delegate = self
    }
    
    @IBAction func changeProfilePic(_ sender: Any) {
        let alertViewController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler:{ (action:UIAlertAction) -> Void in
            self.openCamera()
        })
        let photoAction = UIAlertAction(title: "アルバム", style: .default, handler:{ (action:UIAlertAction) -> Void in
            self.openAlbum()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(photoAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
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
            settingIconImage.contentMode = .scaleToFill
            settingIconImage.image = pickedImage
        }else{
            print("Something went wrong!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newUserName = settingUserNameText.text!
        settingUserNameText.resignFirstResponder()
        return true
    }

    
    @IBAction func settingDone(_ sender: Any) {
        
        //ユーザーIDの取得
        let uid = Auth.auth().currentUser?.uid
        //ユーザー名
        let userName = settingUserNameText.text!
        //プロフィール画像
        let iconImage = settingIconImage.image!
        var iconData:NSData = NSData()
        iconData = UIImageJPEGRepresentation(iconImage, 0.1)! as NSData
        let iconImageString = iconData.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters)
        let updateValues = ["userID":uid!, "userName":userName,"profileImage":iconImageString] as [String : Any]
        reference.child("Users").observeSingleEvent(of: .value, with: {(snapshot) in
            for (_, child) in snapshot.children.enumerated(){
                let key: String = (child as AnyObject).key
                self.reference.keepSynced(true)
                self.reference.child("Users").child(key).updateChildValues(updateValues)
            }
        })
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func settingCancel(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
}
