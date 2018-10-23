//
//  Userdata.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/14.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import Foundation
import RealmSwift
//間者データ
class Userdata: Object {
    @objc dynamic var id = 0
    @objc dynamic var date = Date() //初期登録日
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var sex = ""   //性別
    //id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
    //健康情報データ（検索度に登録）
    let healthData = List<HealthData>()
}
//健康情報データ
class HealthData: Object {
    @objc dynamic var nurseid = 0 //登録した看護士ID
    @objc dynamic var date = Date() //検査日
    @objc dynamic var weight = 0
    @objc dynamic var bloodmax = 0
    @objc dynamic var bloodmin = 0
}
