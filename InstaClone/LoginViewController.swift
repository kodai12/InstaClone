//
//  LoginViewController.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/09.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if emailTextField.isFirstResponder{
            emailTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    
    }
    
    @IBAction func createNewUser(_ sender: Any) {
        if (emailTextField.text == nil || passwordTextField.text == nil){
            let alertViewController = UIAlertController(title: "error", message: "入力欄が空の状態です", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "hoge", style: .default, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
        }else{
            // 新規ユーザー登録
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user,error) in
                if error == nil {
                    
                    UserDefaults.standard.set("loginCheck", forKey: "loginCheck")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alertViewController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "hoge", style: .cancel, handler: nil)
                    alertViewController.addAction(okAction)
                    self.present(alertViewController, animated: true, completion: nil)
                }
            })
            // 次のVCに遷移
            performSegue(withIdentifier: "toFirstSetting", sender: nil)
        }
    }
    

    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user,error) in
            if error == nil{
                
            } else{
                let alertViewController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "hoge", style: .cancel, handler: nil)
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated: true, completion: nil)
            }
        })
    }
    
}
