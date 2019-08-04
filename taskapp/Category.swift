//
//  Category.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/08/04.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import Foundation

import RealmSwift

class Category: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // カテゴリー追加
    @objc dynamic var categoryName = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
