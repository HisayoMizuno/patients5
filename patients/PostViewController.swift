//
//  PostViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var weightTextField: UITextField! //体重
    @IBOutlet weak var bloodmaxTextField: UITextField! //血圧上
    @IBOutlet weak var bloodminTextField: UITextField! //血圧下
    @IBOutlet weak var viewname: UILabel! //名前
    @IBOutlet weak var viewsex: UILabel! //性別
    @IBOutlet weak var viewage: UILabel! //年齢

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButon: UIButton!
    @IBOutlet weak var modButon: UIButton!
    
    let realm = try! Realm()
    var userdata:Userdata!  // 渡ってくる
    let healthData = List<HealthData>()
    var uid = 0
    var healthdataArray: Results<HealthData>?
    var userdataArray: Results<Userdata>?
    var index = 0

    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //------------------------------------------------
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
        
        viewname.text = userdata.name
        viewage.text = String(userdata.age)
        viewsex.text = userdata.sex
        modButon.isHidden = true //変更実行　無効化

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
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
        cell.detailTextLabel?.text = String(healthdata.weight)
        return cell
        
    }
    // セルが選択された時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        print("-------------")
        print(index)
        modButon.isHidden = false //有効化
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
        
    //変更実行時
    @IBAction func healthdataMod(_ sender: Any) {
        print("-------------")
        print("選択されたindex = \(index)")
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
            var health = HealthData(value: [
                "nurseid" : userdata.id ,
                "weight"  : Int(self.weightTextField.text!),
                "bloodmax": Int(self.bloodmaxTextField.text!),
                "bloodmin": Int(self.bloodminTextField.text!)
            ])
            //変更処理
            print("before: \(userdata.healthData)")
            
            try! realm.write {
                userdata.healthData.replace(index: index, object: health)
            }
            
            print("after: \(userdata.healthData)")
            tableView.reloadData()
            addButon.isHidden = false //変更実行　有効化
            modButon.isHidden = true //変更実行　無効化
            //入力項目をセットする
            self.weightTextField.text = ""
            self.bloodmaxTextField.text = ""
            self.bloodminTextField.text = ""
            viewAlert(sts: 0)
            
        }
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
    // 削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                //userdata.healthData.remove(at: index)
                var a = userdata.healthData[index]
                print(a)
                print("aaaaaaa= \(a)")
                //self.realm.delete(userdata.healthData[index])
                //healthdataArray = try! Realm().objects(HealthData.self).filter("nurseid == %@",uid).sorted(byKeyPath: "date", ascending: true)
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
        let okayButton = UIAlertAction(title: NGText, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okayButton)
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
        tableView.reloadData() //画面に戻った時、一覧を更新しておく
    }
    //--------------------------------------------------------------------------------------------
    
    
}


