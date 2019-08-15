//
//  MakeCategoryViewController.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/08/03.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class MakeCategoryViewController: UIViewController,  UITextFieldDelegate {

   @IBOutlet weak var makeCategoryTextField: UITextField!
    
    // Realmインスタンスを取得
    let realm = try! Realm()
    // categoryを定義
    var category: Category!
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
//    var categoryTaskArray = try! Realm().objects(Category.self).sorted(byKeyPath: "date", ascending: false)  // ←追加
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // テキストフィールドデリゲート
        makeCategoryTextField.delegate = self
    }
    
    // 追加ボタンが押されたとき
    @IBAction func pushCategoryButton(_ sender: Any) {
        // カテゴリー作成欄が空文字の場合、カテゴリー作成しない
        if let title = makeCategoryTextField.text {
            if title.isEmpty {
                return
            } else {
                print(makeCategoryTextField.text!)
                try! realm.write {
                    // カテゴリーを追加
                    self.category.categoryName = self.makeCategoryTextField.text!
                    self.realm.add(self.category, update: true)
                    
                    // Realmデータベースファイルまでのパスを表示
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
            }
        }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
