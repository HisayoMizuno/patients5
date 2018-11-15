//
//  UseraddViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/15.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class UseraddViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {


    let realm = try! Realm()
    let userdata = Userdata()
    var moduserdata:Userdata! = nil //画面遷移

    @IBOutlet weak var addButon: UIButton!
    @IBOutlet weak var modButon: UIButton!
    @IBOutlet weak var delButon: UIButton!
    
    @IBOutlet weak var canButon: UIButton! //キャンセル
    @IBOutlet weak var bakButon: UIButton! //一覧へ戻る
    
    //名前テキストボックス
    @IBOutlet weak var nameTextField: UITextField!
    //年齢
    @IBOutlet weak var ageTextField: UITextField!
    //性別テキストボックス
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var sexPickerView: UIPickerView!
    let sexdataList = ["男性","女性"]


   
    //キャンセル
    @IBAction func cancelButton(_ sender: UIButton) {
        //unwindowで戻る
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        //登録時
        if moduserdata == nil {
            //性別Picker用　Delegate設定
            sexTextField.text = ""
            addButon.isHidden = false //表示
            modButon.isHidden = true //非表示
            bakButon.isHidden = true //View
            canButon.isHidden = false //Hidden
        }
        else{ //患者データ変更時
            self.nameTextField.text = moduserdata.name
            self.ageTextField.text = String(moduserdata.age)
            if moduserdata.sex == "男性" {
                sexPickerView.selectRow(0, inComponent: 0, animated: true)
                sexTextField.text = sexdataList[0]
            }
            else {
                sexPickerView.selectRow(1, inComponent: 0, animated: true)
                sexTextField.text = sexdataList[1]
            }
            addButon.isHidden = true //非表示
            modButon.isHidden = false //表示
            bakButon.isHidden = true //View
            canButon.isHidden = false //Hidden
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-----Picker処理--------------------------------------------------------
    // UIPickerViewの列の数
    func numberOfComponents(in sexpickerView: UIPickerView) -> Int {
        return 1
    }
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexdataList.count
    }
    // UIPickerViewの最初の表
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexdataList[row]

        print("男性＝＝\(sexdataList[0])")
        print("女性＝＝\(sexdataList[1])")

        if userdata.sex == "男性" {
            return sexdataList[0]
        }
        else{
            return sexdataList[1]
        }

    }
    //UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(component) == \(row)")
        sexTextField.text = sexdataList[row]
    }
    //---------------------------------------------------------------------
    func viewAlertUser(sts: Int){
        var msg = ""
        var ngword = "NG!入力確認"
        switch sts {
        case 1 : msg = "名前が空白です"; break
        case 2 : msg = "性別を選択してください"; break
        case 3 : msg = "年程が空白です"; break
        case 4 : msg = "変更実行しました"; break
        case 5 : msg = "削除実行しました"; break
        default:
            msg = "入力完了です"
            ngword = "OK"
            break;
        }
        let title = "ポップアップです"
        let message = msg
        let NGText = ngword
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okayButton = UIAlertAction(title: NGText, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }
    
    //------------------------
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    //--------------------------------------------------
    //削除実行
    @IBAction func userdelButon(_ sender: Any) {
      print("DelUserDats AND HedalthData")
        bakButon.isHidden = false //View
        canButon.isHidden = true  //Hidden
         let Alert = UIAlertController(title: "アラート表示", message: "この患者情報を削除していいですか", preferredStyle:  UIAlertControllerStyle.actionSheet)
        let ngAlert = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("今からUSER削除キャンセル")
        })
        let okAlert: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("今から削除実行処理")
            try! self.realm.write {
                //self.realm.delete(self.userdata.healthData[self.index])
                if self.moduserdata.healthData.count >= 1 {
                    self.realm.delete(self.moduserdata.healthData)
                    self.realm.delete(self.moduserdata)
                    
                }
            }
            self.nameTextField.text = ""
            self.sexTextField.text = ""
            self.ageTextField.text = String("")
            self.viewAlertUser(sts: 5)
        })
        Alert.addAction(ngAlert)
        Alert.addAction(okAlert)
        //Alertを表示
        present(Alert, animated: true, completion: nil)
        
    } //END DEL
    
    //変更実行-----------------------------------------------
    @IBAction func usermodButon(_ sender: UIButton) {
        print("ModUserdata === \(moduserdata)")
        if self.nameTextField.text == "" {
            viewAlertUser(sts: 1)
        }
        else if self.sexTextField.text == "" {
            viewAlertUser(sts: 2)
        }
        else if self.ageTextField.text == "" {
            viewAlertUser(sts: 3)
        }
        else{
            try! realm.write {
                //print("入力内容は？？　\(self.nameTextField.text)")
                self.moduserdata.name = self.nameTextField.text!
                self.moduserdata.sex = self.sexTextField.text!
                self.moduserdata.age = Int(self.ageTextField.text!)!
                self.realm.add(self.moduserdata, update: true)
            }
            //ボタン変更など
            self.nameTextField.text = ""
            self.sexTextField.text = ""
            self.ageTextField.text = String("")
            addButon.isHidden = false //変更実行　有効化（非表示）
            modButon.isHidden = true //変更実行　無効化（表示）
            viewAlertUser(sts: 4)
        }
    }
    
    
    
    //新規登録実行-----------------------------------------------
    @IBAction func useraddButon(_ sender: UIButton) {
        print("登録実行")
        if self.nameTextField.text == "" {
            viewAlertUser(sts: 1)
        }
        else if self.sexTextField.text == "" {
            viewAlertUser(sts: 2)
        }
        else if self.ageTextField.text == "" {
            viewAlertUser(sts: 3)
        }
        else{
            let allusers = realm.objects(Userdata.self)
            if allusers.count != 0 {
                self.userdata.id = allusers.max(ofProperty: "id")! + 1
            }
            //let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            print(self.nameTextField.text!)
            print(self.ageTextField.text!)
            try! realm.write {
                self.userdata.name = self.nameTextField.text!
                self.userdata.age = Int(self.ageTextField.text!)!
                self.userdata.sex = self.sexTextField.text!
                self.realm.add(self.userdata, update: true)
            }
            //ボタン変更など
            self.nameTextField.text = ""
            self.sexTextField.text = ""
            self.ageTextField.text = String("")
            addButon.isHidden = true //　無効化（表示）
            modButon.isHidden = false //有効化（非表示）
            viewAlertUser(sts: 0)
            print(Realm.Configuration.defaultConfiguration.fileURL!) //realmブラウザで見る場所
        }
    }
    //データ保持「検査情報ページ」へ戻るための処理-----------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        //データ保持
        let userDefaults = UserDefaults.standard
        let modtext = self.nameTextField.text!
        print("STR====\(modtext)")
        userDefaults.set(modtext, forKey: "name")
        userDefaults.synchronize()
    }
    //一覧ページへ戻る----------------------------------------------------
    
    @IBAction func BackUsrList(_ sender: Any) {
        performSegue(withIdentifier: "UserToTop",sender: nil)

    }

} //end ClassuseraddViewController

