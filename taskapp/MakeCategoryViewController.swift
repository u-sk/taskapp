//
//  MakeCategoryViewController.swift
//  taskapp
//
//  Created by 板垣有祐 on 2019/08/03.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
//import RealmSwift

class MakeCategoryViewController: UIViewController,  UITextFieldDelegate {

   @IBOutlet weak var makeCategoryTextField: UITextField!
    
//    // Realmインスタンスを取得
//    let realm = try! Realm()
//    // categoryを定義
//    var category: Category!
    
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
    
//    // 遷移元に戻る際にタスクの内容をデータベースに保存する
//    override func viewWillDisappear(_ animated: Bool) {
//        try! realm.write {
//            // カテゴリーを追加
//            self.category.categoryName = self.makeCategoryTextField.text!
//            self.realm.add(self.category, update: true)
//
//            // Realmデータベースファイルまでのパスを表示
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//        }
//        super.viewWillDisappear(animated)
//    }
    
    
    // 追加ボタンが押されたとき
    @IBAction func pushCategoryButton(_ sender: Any) {
        print(makeCategoryTextField.text!)
        
        
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            // segueから遷移先のInputViewControllerを取得する
//            let inputViewController:InputViewController = segue.destination as! InputViewController
//            // 遷移先のResultViewControllerで宣言しているdateListに値を代入して渡す
//            inputViewController.x = makeCategoryTextField.text!
//        }
        
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
