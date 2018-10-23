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

    //名前テキストボックス
    @IBOutlet weak var nameTextField: UITextField!
    //年齢
    @IBOutlet weak var ageTextField: UITextField!
    //性別テキストボックス
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var sexPickerView: UIPickerView!
    let sexdataList = ["男性","女性"]


    
    //新規登録実行
    @IBAction func useraddButton(_ sender: UIButton) {
        print("登録実行")
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
            //self.userdata.age = self.ageTextField.text!
            self.userdata.sex = self.sexTextField.text!
            self.realm.add(self.userdata, update: true)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
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
            //sexPickerView.delegate = self
            //sexPickerView.dataSource = self
            sexTextField.text = ""
        }
        else{ //患者データ変更時
            self.nameTextField.text = moduserdata.name
            self.ageTextField.text = String(moduserdata.age)
            if moduserdata.sex == "男性" {
                sexTextField.text = sexdataList[0]
            }
            else{
                sexTextField.text = sexdataList[1]
            }

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
    
         //print("ROW＝＝\(sexdataList[row])")
        if moduserdata.sex == "男性" {
            sexTextField.text = sexdataList[0]
        }
        else{
            sexTextField.text = sexdataList[1]
        }
        sexTextField.text = sexdataList[row]
        
    }
    //---------------------------------------------------------------------


}
