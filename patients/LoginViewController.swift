//
//  LoginViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import ESTabBarController
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    //ログインボタンタップ時
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = accountTextField.text, let password = passTextField.text {
            if address.isEmpty || password.isEmpty{
                SVProgressHUD.showError(withStatus: "必要な項目を入力してしてください")
                return
            }
        }
        //HUDで処理中を表示
         SVProgressHUD.show()
            
        //Json通信を使ってログイン承認
       let result = 1  //0=未ログイン  1=ログイン中
        
       if result != 1 {
            print("DEBUG_PRINT: ログ成功")
            SVProgressHUD.showError(withStatus: "サイインに失敗しました")
            return
        }
        else{
            print("DEBUG_PRINT: ログイン成功")
            //HUDをとじる
            SVProgressHUD.dismiss()
            //画面を閉じてVIewControllerに戻る
            self.dismiss(animated: true , completion: nil)
        }

    } //end handleLoginButton
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    } //end viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
