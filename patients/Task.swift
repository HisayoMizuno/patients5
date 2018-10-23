//
//  Task.swift
//  patients
//
//  Created by 水野 久代 on 2018/08/14.
//  Copyright © 2018年 水野 久代. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    // プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var ccount = ""
    // 内容
    @objc dynamic var password = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
