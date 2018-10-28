//
//  HomeViewController.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/13.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    // DB内のタスクが格納されるリスト。
    var userdataArray = try! Realm().objects(Userdata.self).sorted(byKeyPath: "date", ascending: false)

    // 戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //画面が戻ってきた時
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.placeholder = "検索"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        print("ここは　HomeViewController の　viewDidLoad です")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //検索するーーーーーーーーーーーーーーー
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            userdataArray = try! Realm().objects(Userdata.self).sorted(byKeyPath: "date", ascending: false)
        }
        else{
            //let contain = NSPredicate(format: "name CONTAINS %@ AND age == @%", searchBar.text!)
            let contain = NSPredicate(format: "name CONTAINS %@ ", searchBar.text!)

            userdataArray = try! Realm().objects(Userdata.self).filter(contain).sorted(byKeyPath: "date", ascending: false)
        }
        tableView.reloadData()
    }
    //検索ここまでーーーーーーーーーーーーーーーーーー
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ここは　HomeViewの　numbewOfRowsSection count部分です")
        return userdataArray.count
    }
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("HomeView_numbreOfRowInSection aaaa")

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cellにセット
        let userdata = userdataArray[indexPath.row]
        cell.textLabel?.text = userdata.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: userdata.date)
        cell.detailTextLabel?.text = dateString
        print(dateString)
        
        return cell
    }
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する  // ←以降追加する
            try! realm.write {
                self.realm.delete(self.userdataArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // 患者追加
    @IBAction func useraddButton(_ sender: UIButton) {
        let useraddViewController = self.storyboard?.instantiateViewController(withIdentifier: "Useradd") as! UseraddViewController
        useraddViewController.modalPresentationStyle = .overCurrentContext
        useraddViewController.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.9)

        present(useraddViewController, animated: true, completion: nil)
    }
    //患者の健康情報データ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let indexPath = self.tableView.indexPathForSelectedRow
        let postViewController:PostViewController = segue.destination as! PostViewController
        postViewController.userdata = userdataArray[indexPath!.row]
        postViewController.modalPresentationStyle = .overCurrentContext
        postViewController.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.9)
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        tableView.reloadData() //画面に戻った時、一覧を更新しておく
    }

}
