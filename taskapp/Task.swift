//
//  Task.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/07/25.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import Foundation

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    // カテゴリー追加
    @objc dynamic var category = ""

    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
