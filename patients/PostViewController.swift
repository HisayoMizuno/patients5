//
//  PostViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var weightTextField: UITextField! //体重
    @IBOutlet weak var bloodmaxTextField: UITextField! //血圧上
    @IBOutlet weak var bloodminTextField: UITextField! //血圧下
    @IBOutlet weak var viewname: UILabel! //名前
    @IBOutlet weak var viewsex: UILabel! //性別
    @IBOutlet weak var viewage: UILabel! //年齢
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButon: UIButton!
    @IBOutlet weak var modButon: UIButton!
    @IBOutlet weak var delBoton: UIButton!
    
    let realm = try! Realm()
    var userdata:Userdata!  // 渡ってくる
    var moduserdata:Userdata! //ユーザ変更実行時に渡ってくる
    let healthData = List<HealthData>()
    var uid = 0
    var healthdataArray: Results<HealthData>?
    var userdataArray: Results<Userdata>?
    var index = 0
    //データ保持インスタンス作成
    let userDefaults = UserDefaults.standard

    //---画面が表示される直前---------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let aftername: String? = userDefaults.object(forKey: "name") as? String
        print("############unwind時の名前は？？？　\(aftername)")
        tableView.reloadData() //画面に戻った時、一覧を更新しておく
        viewname.text = userdata.name
        viewage.text = String(userdata.age)
        viewsex.text = userdata.sex
        


    }
    //---インスタンス化された直後（初回に一度のみ）----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        uid = userdata.id
        print("uid")
        healthdataArray = try! Realm().objects(HealthData.self).filter("nurseid == %@",uid).sorted(byKeyPath: "date", ascending: true)
        for a in healthdataArray! {
            print("nurse= \(a.nurseid) : weight= \(a.weight)")
        }
        userdataArray = try! Realm().objects(Userdata.self).filter("id=%@",uid).sorted(byKeyPath: "date", ascending: false)
        for b in userdataArray! {
            print("uid= \(b.id) : name= \(b.name)")
        }
        //---
        viewname.text = userdata.name
        viewage.text = String(userdata.age)
        viewsex.text = userdata.sex
        modButon.isHidden = true //変更実行　無効化
        delBoton.isHidden = true //削除実行　無効化

        
        //データ保持
        userDefaults.set(userdata.name , forKey: "name")
        userDefaults.synchronize()
        let aftername: String? = userDefaults.object(forKey: "name") as? String
        print("+++++++++++ViewDidload時の名前は viewDidLoad？？？　\(aftername)")

    }
    //--------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //--------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count")
        //return (healthdataArray?.count)!
        return userdata.healthData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let uid = userdata.id
        //cellにセット
        //let healthdata = healthdataArray?[indexPath.row]
        let healthdata = userdata.healthData[indexPath.row]

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: (healthdata.date))
        cell.textLabel?.text = dateString
        var subtitle:String =  String(healthdata.weight) + "kg/ " + String(healthdata.bloodmax) + "mmHG/ "
        subtitle += String(healthdata.bloodmin) + "mmHG"
        //cell.detailTextLabel?.text = String(healthdata.weight)
        cell.detailTextLabel?.text = subtitle
        return cell
        
    }
    // セルが選択された時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        print("-------------")
        print(index)
        modButon.isHidden = false //有効化
        delBoton.isHidden = false //有効化
        addButon.isHidden = true //無効化
        //let a = self.tableView.indexPathForSelectedRow
        //let healthdata = healthdataArray?[indexPath.row]
        
        //let healthdata = healthdataArray?[indexPath.row]
        
        let healthdata = userdata.healthData[indexPath.row]
        
        weightTextField.text = healthdata.weight.description
        bloodmaxTextField.text = healthdata.bloodmax.description
        bloodminTextField.text = healthdata.bloodmin.description
        print(healthdata.weight)
    }
        

    //登録実行
    @IBAction func healthdataAdd(_ sender: Any) {
        //viewAlert()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if self.weightTextField.text == "" {
            print("NULLA")
            viewAlert(sts: 1)
        }
        else if self.bloodmaxTextField.text == "" {
             print("NULLB")
            viewAlert(sts: 2)
        }
        else if self.bloodminTextField.text == "" {
            print("NULLC")
            viewAlert(sts: 3)
        }
        else {
            let health = HealthData(value: [
                "nurseid" : userdata.id ,
                "weight"  : Int(self.weightTextField.text!),
                "bloodmax": Int(self.bloodmaxTextField.text!),
                "bloodmin": Int(self.bloodminTextField.text!)
            ])
            //登録処理
            try! realm.write {
                userdata.healthData.append(health)
            }
            tableView.reloadData()
            //入力項目をセットする
            self.weightTextField.text = ""
            self.bloodmaxTextField.text = ""
            self.bloodminTextField.text = ""
            viewAlert(sts: 0)
        }
    }
    //変更実行時------------------------------------------
    @IBAction func healthdataMod(_ sender: Any) {
        print("選択されたindex = \(index)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if self.weightTextField.text == "" {
            viewAlert(sts: 1)
        }
        else if self.bloodmaxTextField.text == "" {
            viewAlert(sts: 2)
        }
        else if self.bloodminTextField.text == "" {
            viewAlert(sts: 3)
        }
        else {
            let Alert = UIAlertController(title: "アラート表示", message: "変更していいですか", preferredStyle:  UIAlertControllerStyle.actionSheet)
            let ngAlert = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("今から変更キャンセル")
                //入力項目をセットする
                self.weightTextField.text = ""
                self.bloodmaxTextField.text = ""
                self.bloodminTextField.text = ""
            })
            let okAlert: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("今から変更実行処理")
                
                let health = HealthData(value: [
                    "nurseid" : self.userdata.id ,
                    "weight"  : Int(self.weightTextField.text!),
                    "bloodmax": Int(self.bloodmaxTextField.text!),
                    "bloodmin": Int(self.bloodminTextField.text!)
                ])

                //変更処理
                print("after: \(self.userdata.healthData)")
                print("before: \(self.userdata.healthData)")
                try! self.realm.write {
                    print("今から変更実行処理222")

                    self.userdata.healthData.replace(index: self.index, object: health)
                    print("今から変更実行処理333")

                }
                //入力項目をセットする
                self.weightTextField.text = ""
                self.bloodmaxTextField.text = ""
                self.bloodminTextField.text = ""
                self.addButon.isHidden = false //変更実行　有効化
                self.modButon.isHidden = true //変更実行　無効化
                self.tableView.reloadData()

                self.viewAlert(sts: 0)
            })
            Alert.addAction(ngAlert)
            Alert.addAction(okAlert)
            // ④ Alertを表示
            present(Alert, animated: true, completion: nil)

        }
    }
    //削除------------------------------¡
    @IBAction func healthdataDel(_ sender: Any) {
        print("選択されたindex = \(index)")
        
        let Alert = UIAlertController(title: "アラート表示", message: "削除していいですか", preferredStyle:  UIAlertControllerStyle.actionSheet)
        let ngAlert = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("今から削除キャンセル")
        })
        
        let okAlert: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("今から削除実行処理")
            try! self.realm.write {
                self.realm.delete(self.userdata.healthData[self.index])
            }
          self.tableView.reloadData()
           self.viewAlert(sts: 5)
        })
        Alert.addAction(ngAlert)
        Alert.addAction(okAlert)
        // ④ Alertを表示
        present(Alert, animated: true, completion: nil)
        
        //---
        self.addButon.isHidden = false //変更実行　有効化
        self.modButon.isHidden = true //変更実行　無効化
        //入力項目をセットする
        self.weightTextField.text = ""
        self.bloodmaxTextField.text = ""
        self.bloodminTextField.text = ""
    }
    
    
    // 削除
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                //userdata.healthData.remove(at: index)
                var a = userdata.healthData[index]
                print(a)
                print("aaaaaaa= \(a)")

                self.realm.delete(userdata.healthData[indexPath.row])
            }
        }
        tableView.reloadData()
        addButon.isHidden = false //変更実行　有効化
        modButon.isHidden = true //変更実行　無効化
        //入力項目をセットする
        self.weightTextField.text = ""
        self.bloodmaxTextField.text = ""
        self.bloodminTextField.text = ""
        tableView.reloadData()
        viewAlert(sts: 5)
        
    }
    */
    //--------------------------
    func viewAlert(sts: Int) {
        var msg = ""
        var ngword = "NG!入力確認"
        switch sts {
        case 1 :  msg = "体重が入力されていません"; break
        case 2 :  msg = "血圧（上）体重が入力されていません"; break
        case 3 :  msg = "血圧（下）体重が入力されていません"; break
        case 4 :  msg = "変更実行しました"; break
        case 5 :  msg = "削除実行しました"; break
        case 6 :  msg = "削除してもよいですか"; break
        default: //0の時
            msg    = "入力完了です";
            ngword = "OK";
            break
        }
        let title = "入力確認のポップアップ"
        let message = msg
        let NGText = ngword
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: NGText, style: UIAlertActionStyle.cancel, handler: nil)
        //let ngButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        //alert.addAction(ngButton)

        present(alert, animated: true, completion: nil)
        }
    //---------------------------------------
    //患者情報変更
    /*
    @IBAction func Usermod(_ sender: UIButton) {
        let useraddViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsermodSegue") as! UseraddViewController
        useraddViewController.moduserdata = userdata
        useraddViewController.modalPresentationStyle = .overCurrentContext
        useraddViewController.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.9)
        present(useraddViewController, animated: true, completion: nil)
    }
    */
    

    @IBAction func Usermod(_ sender: UIButton) {
        print("userdata = \(String(describing: userdata))")
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="UsermodSegue") {
            print("userdata = \(String(describing: userdata))")
            let useraddViewController:UseraddViewController = segue.destination as! UseraddViewController
            useraddViewController.moduserdata = userdata
            useraddViewController.modalPresentationStyle = .overCurrentContext
            useraddViewController.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.9)
        }
    }
    

    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        //保持
        
        print("unwind") 
        let aftername: String? = userDefaults.object(forKey: "name") as? String
        print("?????unwind時の名前は？？？　\(String(describing: aftername))")
        viewname.text = aftername
        viewage.text = String(userdata.age)
        viewsex.text = userdata.sex
        tableView.reloadData() //画面に戻った時、一覧を更新しておく
    }
    //--------------------------------------------------------------------------------------------
    
    
}


