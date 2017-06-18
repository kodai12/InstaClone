//
//  PostViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Photos
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    //コメントを保存する変数
    var tempCommentText = String()
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self

        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Bradley Hand",size: 17)!]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tempCommentText = commentTextField.text!
        commentTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (selectedImageView.image == nil){
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
            selectedImageView.contentMode = .scaleToFill
            selectedImageView.image = pickedImage
        }else{
            print("Something went wrong!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        selectedImageView = UIImageView()
        commentTextField = UITextField()
        commentTextField.resignFirstResponder()
        performSegue(withIdentifier: "confirmPost", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmPost"){
            let confirmPostVC:ConfirmPostViewController = segue.destination as! ConfirmPostViewController
            confirmPostVC.editImage = selectedImageView.image!
            confirmPostVC.editComment = commentTextField.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    
}
