//
//  ViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import ESTabBarController


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTab() {        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 3
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChildViewController(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        tabBarController.didMove(toParentViewController: self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        //let postViewController = storyboard?.instantiateViewController(withIdentifier: "Post")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        //abBarController.setView(postViewController, at: 1)
        tabBarController.setView(settingViewController, at: 2)
        

        // 真ん中のタブはボタンとして扱う
        
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post")
            self.present(postViewController!, animated: true, completion: nil)
        }, at: 1)
        
        
    } //end serupTab
    

    //ーーーーー画面呼ばれたとき、ログイン確認ーーーーーー
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let result = 1
        if result != 1 {
            // ログインしていない場合の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)  //モーダル表示
        }
    }//end ViewDidAppear
/*
    //ーーーーー画面呼ばれたとき、ログイン確認ーーーーーー

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Json通信を使ってログイン承認
        let result = 1
        if result != 1 {
            //print("DEBUG_PRINT:" + result)
            //return
        }
        else{
            print("DEBUG_PRINT: ログイン成功")
            // ログインしていない場合の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") 
            self.present(loginViewController!, animated: true, completion: nil)  //モーダル表示
            //画面を閉じてVIewControllerに戻る
            self.dismiss(animated: true , completion: nil)
            
        }
    } //end ViewDidAppear
   */

} //endClass

